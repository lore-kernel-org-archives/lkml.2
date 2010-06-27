Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0F0Qy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 12:54:29 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:43866 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755577Ab0F0Qy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 12:54:27 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: WnacHysVM1kZ.OprkgBBddz9qDrV3kGm04zmyRAvHzJUE4w
 FpSWZJAlMIvKg9rV1LFneu8IYaGX7iHTs_hEcTXAfrZhxayPZ.vzH_0KXd1s
 H7plz7Hvs6zT3q1vqDOSfkswMS96PKy9N1OL_F5ZCgKps6n4wAPlcBsEtzlA
 8pW7BwSArj1GEBjPrxdhh8u3UafSbXoRqTBRXYVD.RkM3FTK1Cvf5WCmnAb3
 Wkz826WhwUFLjr2LvbGoRl.wG.NdgZa30n.OweXuvbaUVzUWZJvQHy1DlS7M
 _BpnJg35gyN9_P2p8vJoUbXXJlluZycZcxd6hIw7oTrPmUUyu2hWkaA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C278241.2020308@schaufler-ca.com>
Date: Sun, 27 Jun 2010 09:54:25 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 02/15] security: move LSM xattrnames to xattr.h
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>	 <1277403031-3080-3-git-send-email-zohar@linux.vnet.ibm.com>	 <4C242745.6050801@schaufler-ca.com> <1277464506.3220.5.camel@localhost.localdomain>
In-Reply-To: <1277464506.3220.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> On Thu, 2010-06-24 at 20:49 -0700, Casey Schaufler wrote: 
>   
>> Mimi Zohar wrote:
>>     
>>> Make the security extended attributes names global.
>>>
>>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
>>> Acked-by: Serge Hallyn <serue@us.ibm.com>
>>> ---
>>>  include/linux/capability.h |    3 ---
>>>  include/linux/xattr.h      |   10 ++++++++++
>>>  security/selinux/hooks.c   |    3 ---
>>>  security/smack/smack.h     |    2 --
>>>  4 files changed, 10 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/linux/capability.h b/include/linux/capability.h
>>> index 39e5ff5..90012b9 100644
>>> --- a/include/linux/capability.h
>>> +++ b/include/linux/capability.h
>>> @@ -49,9 +49,6 @@ typedef struct __user_cap_data_struct {
>>>  } __user *cap_user_data_t;
>>>  
>>>  
>>> -#define XATTR_CAPS_SUFFIX "capability"
>>> -#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
>>> -
>>>  #define VFS_CAP_REVISION_MASK	0xFF000000
>>>  #define VFS_CAP_REVISION_SHIFT	24
>>>  #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
>>> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
>>> index 0cfa1e9..62ca853 100644
>>> --- a/include/linux/xattr.h
>>> +++ b/include/linux/xattr.h
>>> @@ -33,6 +33,16 @@
>>>  #define XATTR_USER_PREFIX "user."
>>>  #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
>>>  
>>> +/* Security namespace */
>>> +#define XATTR_SELINUX_SUFFIX "selinux"
>>> +#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
>>> +
>>> +#define XATTR_SMACK_SUFFIX "SMACK64"
>>> +#define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
>>> +
>>> +#define XATTR_CAPS_SUFFIX "capability"
>>> +#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
>>> +
>>>  struct inode;
>>>  struct dentry;
>>>  
>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>> index 0f524b7..85338f0 100644
>>> --- a/security/selinux/hooks.c
>>> +++ b/security/selinux/hooks.c
>>> @@ -87,9 +87,6 @@
>>>  #include "netlabel.h"
>>>  #include "audit.h"
>>>  
>>> -#define XATTR_SELINUX_SUFFIX "selinux"
>>> -#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
>>> -
>>>  #define NUM_SEL_MNT_OPTS 5
>>>  
>>>  extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
>>> diff --git a/security/smack/smack.h b/security/smack/smack.h
>>> index c6e9aca..9c773e3 100644
>>> --- a/security/smack/smack.h
>>> +++ b/security/smack/smack.h
>>> @@ -126,10 +126,8 @@ struct smack_known {
>>>  /*
>>>   * xattr names
>>>   */
>>> -#define XATTR_SMACK_SUFFIX	"SMACK64"
>>>  #define XATTR_SMACK_IPIN	"SMACK64IPIN"
>>>  #define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
>>> -#define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
>>>  #define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
>>>  #define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
>>>   
>>>       
>> Why just the SMACK64 attribute name, and not the others? They are
>> manipulated with the same interfaces (well, fsetxattr, fgetxattr)
>> as the SMACK64 attribute. There isn't any conceptual difference and
>> the rationale for moving attribute names really ought to apply to
>> them as well.
>>     
>
> Hi Casey,
>
> Moving the other SMACK xattrs is fine, but are they used on persistent
> files and need to be EVM protected?
>   

They are not persistent in any configuration available today, but
as they say, tomorrow never knows. The real reason I'm concerned is
that I always dislike having to go look in two places for something
like attr names. Either global or local is fine, but it should be
one or the other.


> Mimi
>
>
>   

