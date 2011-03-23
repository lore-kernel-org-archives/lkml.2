Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1CWQPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:15:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57919 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1CWQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=pEea6qIKLRuLXji/6E9BI4Bm4MTl2ZTixMX8TPQRbPJE3oF3FxDFzogag4DV04tQ5H
         VCCQjKehumc9W62J5lksZG+wKJAO7xmxiheWlFTU9T88o1v0J9EH9+5YEI9rbs3VL+eb
         JzgmGAIMgh2hhTpV3A3dqmByHNhk0NA3D/v4g=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Roger Quadros" <roger.quadros@nokia.com>,
        "Alan Stern" <stern@rowland.harvard.edu>
Cc: gregkh@suse.de, sshtylyov@mvista.com,
        "USB list" <linux-usb@vger.kernel.org>,
        "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
References: <Pine.LNX.4.44L0.1103231110400.2211-100000@iolanthe.rowland.org>
Date: Wed, 23 Mar 2011 17:14:22 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vss0p8h93l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1103231110400.2211-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On the other hand, I don't think any implementations would get upset  
>>> if we simply ended the transfer with a short packet instead of
>>> adhering strictly to the spec.

> On Wed, 23 Mar 2011, Roger Quadros wrote:
>> I tried your patch with the CD-ROM implementation and it works  
>> perfectly. I do not see the unnecessary zero padded transfers
>> any more.
>>
>> Do you think we should have this patch in? with the risk of not strictly
>> adhering to spec for cases where controller cannot stall?

On Wed, 23 Mar 2011 16:17:32 +0100, Alan Stern wrote:
> There already is another place where not stalling forces the driver to
> violate the spec.  I don't think this makes things much worse... but it
> is a significant change in behavior.
>
> This affects Michal's driver too; we should ask his opinion.  Michal,
> in case you didn't see it, the proposed patch is here:
>
> 	http://marc.info/?l=linux-usb&m=130080683528607&w=2

Thanks.  I don't have original message so I'll reply here:

> +		/* Don't know what to do if common->fsg is NULL */
> +		} else if (!common->fsg) {
> +			rc = -EIO;
> +

I'd change that to "if (!fsg_is_set(common))".  fsg_is_set() prints out a  
warning
if common->fsg is not set and I think that's something we want.

(Come to think of it, this check should be done at the beginning of the  
function
simplifying the rest of the function, but that's unrelated, I'll do it  
myself I
guess.)

Other then that, looks good to me.

As for violating the spec, I don't think I have anything clever to add...

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
