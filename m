Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1D0UUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:20:03 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47827 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751954Ab1D0UUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:20:00 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: bLh19UgVM1mGS9RfuuHDTy5KoxG_GAM7PoWQiEBBy8UHsY7
 sgxuUU_qOH2JF4A_nluyVBmfp40KzmVnQcnApDG5ratJ2TYgwlbTPSQiFBe0
 xwxQVsj9jU5_2qMAlRUrhlrhoCTxiTcwAYt_6eh9pFMm3R58NQxsIcz4qGpN
 YDVqDQclE31mQeSZHPqQOqt1tBL6_bxPUIUkF.tFWMB5dsmQVbHrPRoYuJGp
 EhRXS04jD1a5Ag.ydPrxr.SJ0QvA5usrQhRrA.cs9PLi7dVQx6waTlXlaSVu
 c31g53.Ih.l9tSw4n_0NWpIiMefMFKEwfMlOl3MLNFDILtEGFiJQAywgoNya
 NTIvzjoKV56HsCVC45Ppip7wT4pD2NBkX_A--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB87A6B.7060805@schaufler-ca.com>
Date: Wed, 27 Apr 2011 13:19:55 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> File descriptor labeling issue
>
> Actually SELinux and SMACK assign to file descriptors the same label of the
> opening process and use it in LSM hooks security_file_permission(),
> security_file_fcntl() and others to verify if the 'current' process has the
> rights to perform the requested operation.
>
> Using the credentials of the 'current' process may be not appropriate in
> case a file descriptor is opened by a kernel service (i.e. a filesystem)
> and made shared among user processes. For instance, in a system with
> SELinux and eCryptfs, if the process A opens an encrypted file, eCryptfs
> obtains a file descriptor to access the correspondent inode in the lower
> filesystem, labeled with the A's label.
>
> If the process B accesses the same encrypted file, it needs the 'use'
> permission on the A's label other than permissions for the lower inode.
> However, if B is the first accessing process, A needs the 'use' permission
> on the B's label.

I am having trouble understanding the argument. I will pose my
question in Smack terms, as I can speak most definitively in them.

A process running with a Smack label "A" creates a file, and that
file gets labeled "A", as it ought. If eCryptfs is behaving correctly
this ought not change. If eCryptfs in encrypting the label it needs
to do so in such a way as to be able to decrypt it prior to
presentation to the vfs layer, where it will be used in an access
check. When the process running with a Smack label "B" comes along
the vfs code will check the fetched and possibly decrypted "A"
against "B" and, unless there is an explicit Smack rule in place
granting "B" access to "A", fail.

What is the problem? What is eCryptfs doing that prevents this
from working?


