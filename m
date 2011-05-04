Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1EDRez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:34:55 -0400
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:35724 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753528Ab1EDRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:34:53 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: NQp6.ewVM1kpHFBsEYbM.KjxbkB2wQRtKyQLeRwG0437Hv_
 6T3oyBmU9HXDXex1ndQVxRCO7SmJ6JO6RFzI9pHt73MEeIYSzdG4tQ6KUmWP
 bmpIbWDJ.rw1J0RjfXFHE8OemQZ3pNyYRe8xC0C9g0liNgQOnL2bvS7Sv4rI
 V6qYrulE39OEaAg4arKbIJQmTD7BpvqZhQ3Fg01Gc4at.JjvrwPWC5hR3kYi
 bWI5gL.dzN_nF_NCIp0tQJZanSpyj6ZDbZJh40N5ZkvZKW8KdM5tEF7jKSPh
 3XaLYW_PsqAojbakP2.78VNXlRY6Xxwn60u4oBL4oZS63MajrdB4OkxO1iVY
 eoOoOFzSluYNVSBw5uEBSWNEkMH2T3V44tQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DC18E3B.2000104@schaufler-ca.com>
Date: Wed, 04 May 2011 10:34:51 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: John Johansen <john.johansen@canonical.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        eparis@redhat.com, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        viro@zeniv.linux.org.uk, apparmor@lists.ubuntu.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
References: <201104291139.37489.roberto.sassu@polito.it> <4DC088A8.4000300@schaufler-ca.com> <4DC09688.7090509@canonical.com> <201105041047.57161.roberto.sassu@polito.it>
In-Reply-To: <201105041047.57161.roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/2011 1:47 AM, Roberto Sassu wrote:
> On Wednesday, May 04, 2011 01:58:00 AM John Johansen wrote:
>> ....
>> I have to agree with Casey, Generally looping back through the vfs should
>> be using the user's credentials.  This doesn't even stop you opening the
>> lower file with a different set of permissions (eg.  rw while the upper
>> is opened with r).
> Hi Casey and John
>
> my patch set does not modify this behavior:  VFS calls on upper inodes
> made by user processes and VFS calls (read/write) made by eCryptfs
> on lower inodes still use the user's credentials.
>
> In addition, SELinux provide a model for file descriptors. They may be
> opened by another subject (which provided its own credentials) and
> other processes need the 'use' permission for those file descriptors
> other than permissions for related inodes.
>
> This means that, even if eCryptfs opens lower inodes with its own
> credentials, user processes still need permissions to read/write both
> upper and lower inodes.
>
> One benefit of allowing eCryptfs to provide its own credentials is that
> user processes must have granted only strictly required permissions.
>
> Roberto Sassu

My point is that you should be able to achieve all of what you
say you want to do without introducing the LSM changes you are
proposing.

