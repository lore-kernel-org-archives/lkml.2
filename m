Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2KHRqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:46:48 -0500
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:22897 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755542Ab2KHRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:46:47 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 12:46:47 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QubXyAYVM1njMZP2OY_BbYfR6SfPdpAnHpET5rG_0jZi.dN
 roqdNALb877dXG36hTRuYQjf46BElkKjyz9wY3t3FdV53k823A.qyeQ0PUzY
 a1A21tetm11FNik1BJybJW.JwAfOidgnkfWcEFr4pRqPMta23KbQTHN15oYo
 RN1I7k8tqxCcdH7dTPfjRdsGbJe0_TXdDlQzerk0ky6CfeDEMGNkgsXPZKCV
 zZBsEMkt.OKERo_X10xKGZLGPf.Z3PeYV6ptOeyXx1Z8NoOXntQwcoV8P6H0
 Xo9A1IDQKcrLql1B5tKk1y_nKzpP.lvuyo7m.WxY_8sZv7JMYQetDyQsw.ZH
 5aZ0EnFFFM5rZmHXRMCfLwidb5B5AOfngexikNcGxHYnbI2Ku93gpchoAO_h
 yp4rLNJWu70ZqE4uCIKfTj5vdTjSVQdf7XrHPoIADihAAeOtR9MWxasBEYzs
 8biGsycTk
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <509BEE75.3070107@schaufler-ca.com>
Date: Thu, 08 Nov 2012 09:40:05 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: SMACK_MAGIC to include/uapi/linux/magic.h
References: <1352189869-27190-1-git-send-email-jarkko.sakkinen@iki.fi> <50998834.5030407@schaufler-ca.com> <CAMR49Lp07mn3dOhaN9LpckCHVY7vMBc2SRvp4JqX3cYTtcG=nQ@mail.gmail.com> <CACLa4pv-dutho5OokuoRUYxJ1noNOZV04wvcyQe3wmS9Ux2HPg@mail.gmail.com>
In-Reply-To: <CACLa4pv-dutho5OokuoRUYxJ1noNOZV04wvcyQe3wmS9Ux2HPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2012 7:04 AM, Eric Paris wrote:
> Then it only works by accident that magic.h is included by some random
> path in smackfs.c.  You really should be including it in smack.h (or
> each .c file individually, up to casey)

I should think it should go in smack.h

> On Thu, Nov 8, 2012 at 5:43 AM, Jarkko Sakkinen <jarkko.sakkinen@iki.fi> wrote:
>> On Tue, Nov 6, 2012 at 11:59 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> On 11/6/2012 12:17 AM, Jarkko Sakkinen wrote:
>>>> SMACK_MAGIC moved to a proper place for easy user space access
>>>> (i.e. libsmack).
>>>>
>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
>>>> ---
>>>>  include/uapi/linux/magic.h |    1 +
>>>>  security/smack/smack.h     |    5 -----
>>>>  2 files changed, 1 insertion(+), 5 deletions(-)
>>> Will security/smack/smack_lsm.c and security/smack/smackfs.c
>>> compile after this change?
>> Sorry I haven't replied earlier. Anyway, I made a sanity check.
>>
>> I retried build from clean. Works. I also checked that vmlinux contains
>> SMACK symbols. It does.
>>
>>>> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
>>>> index e15192c..12735ad 100644
>>>> --- a/include/uapi/linux/magic.h
>>>> +++ b/include/uapi/linux/magic.h
>>>> @@ -11,6 +11,7 @@
>>>>  #define DEBUGFS_MAGIC          0x64626720
>>>>  #define SECURITYFS_MAGIC     0x73636673
>>>>  #define SELINUX_MAGIC                0xf97cff8c
>>>> +#define SMACK_MAGIC          0x43415d53      /* "SMAC" */
>>>>  #define RAMFS_MAGIC          0x858458f6      /* some random number */
>>>>  #define TMPFS_MAGIC          0x01021994
>>>>  #define HUGETLBFS_MAGIC      0x958458f6      /* some random number */
>>>> diff --git a/security/smack/smack.h b/security/smack/smack.h
>>>> index 99b3612..8ad3095 100644
>>>> --- a/security/smack/smack.h
>>>> +++ b/security/smack/smack.h
>>>> @@ -149,11 +149,6 @@ struct smack_known {
>>>>  #define SMACK_CIPSO_SOCKET   1
>>>>
>>>>  /*
>>>> - * smackfs magic number
>>>> - */
>>>> -#define SMACK_MAGIC  0x43415d53 /* "SMAC" */
>>>> -
>>>> -/*
>>>>   * CIPSO defaults.
>>>>   */
>>>>  #define SMACK_CIPSO_DOI_DEFAULT              3       /* Historical */
>> /Jarkko
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

