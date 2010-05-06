Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0EFXYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:24:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36322 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0EFXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cfG7ZVkOGFQwAIiC8xJOH55pSyj1eVfzLsW3lva5XWlKT8sQQw3FniLoLMuLNDzLuI
         B4lDRWjD9vMWrvtweHF/SGJIvwizF93B7HCcST6AiL0XUoKWGci0itb9VQJSxGxjL7r1
         MRR2JvLkHRXwlgioQ3DtQepDrcCm+W+a1M3HY=
Message-ID: <4BE34FA5.8070906@gmail.com>
Date: Thu, 06 May 2010 16:24:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: David Howells <dhowells@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: linux-next: manual merge of the security-testing tree with Linus'
 tree
References: <20100506123049.082e98cc.sfr@canb.auug.org.au> <7197.1273142988@redhat.com> <alpine.LRH.2.00.1005070908230.31779@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1005070908230.31779@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 04:10 PM, James Morris wrote:
> On Thu, 6 May 2010, David Howells wrote:
>
>>
>> Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>
>>> I just used the version from Linus' tree.
>>
>> Okay.
>>
>> However, I'd like to NAK some bits of c5b60b5e67af8be4c58d3ffcc36894f69c4fbdc1
>> now that I see it...
>
> Will a patch -R of below be correct enough for you?  Otherwise, please
> send me a new patch.
>
> (This is one of the reasons why I'm not so keen on whitespace fixes, also
> having to resolve merge conflicts, peturbing the history of the code etc.)
>
>
>>
>> 	@@ -1282,16 +1282,16 @@ long keyctl_session_to_parent(void)
>> 	
>> 	        /* the parent must have the same effective ownership and mustn't be
>> 	         * SUID/SGID */
>> 	-       if (pcred->  uid != mycred->euid ||
>> 	+       if (pcred->uid  != mycred->euid ||
>> 	            pcred->euid != mycred->euid ||
>> 	            pcred->suid != mycred->euid ||
>> 	-           pcred->  gid != mycred->egid ||
>> 	+           pcred->gid  != mycred->egid ||
>> 	            pcred->egid != mycred->egid ||
>> 	            pcred->sgid != mycred->egid)
>> 	                goto not_permitted;
>> 	
>> 	        /* the keyrings must have the same UID */
>> 	-       if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
>> 	+       if (pcred->tgcred->session_keyring->uid != mycred->euid ||
>> 	            mycred->tgcred->session_keyring->uid != mycred->euid)
>> 	                goto not_permitted;
>>
>> _Please_ don't do either of these.  The whole point is to line stuff up so
>> that as the eye scans down the lines, it can easily pick out the differences
>> in stuff that's otherwise greatly repetitive.
>>
>> David
>>
>

I never would of thought this. So the != has to be lined
up so things don't break?!

Justin P. Mattock
