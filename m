Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab1D0X0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:26:48 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:26178 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757170Ab1D0X0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:26:47 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: W0pbdC0VM1lLznRCWC3aFHc32FPhWE5f6GVDumLYP1gVoRT
 AdKiJxZVWgT5NqEaTZyuga5kN0wFONH_jYOB3FH9kXj.iWS_NI89RA8qo_mM
 qj0okv_ZLo0vHo.5uqeIXYyd1LXxbBU5BXhBl7IiatagRRf.W7TmM9mRABex
 EO7288hHjytWcMjDXT23xFUObEO1NCAk3Q1cEQDCKulAfMTiGEDy2XQAEqWK
 7bEQvDVB2S9fsDiDdDgJLg4LTfR_X_FDWIJnTxhksWgNaHjPe0DwShPp2oTs
 3_wrl5Y3h23z1Wu3fSktlLBTVrDCXVObGE20SO4NBeq8g3cdRl3gVt5J0iQB
 HAZfIqh0jX3pbPu8fmX38rMt3iL5PBSZfux5YllAM.w--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB8A633.6080102@schaufler-ca.com>
Date: Wed, 27 Apr 2011 16:26:43 -0700
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
Subject: Re: [RFC][PATCH 3/7] smack: assign the label set in file->f_cred
 to new file descriptors
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <1303907657-18366-4-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1303907657-18366-4-git-send-email-roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> The SMACK label of new file descriptors is obtained from the credentials
> set in the 'f_cred' field of the same structure.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/smack/smack_lsm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index c6f8fca..e3c9e54 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1011,7 +1011,7 @@ static int smack_file_permission(struct file *file, int mask)
>   */
>  static int smack_file_alloc_security(struct file *file)
>  {
> -	file->f_security = smk_of_current();
> +	file->f_security = smk_of_task(file->f_cred->security);

Now hang on. This just looks wrong. You're setting the value of one
field of the file structure to another value in the same file structure.
I don't see that this is what I want.

>  	return 0;
>  }
>  

