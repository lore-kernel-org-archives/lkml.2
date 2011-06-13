Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1FMSOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:14:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab1FMSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cZYd37vM0E8mKA5uzP4+88n8OdXwno33jmbg+gWUcfjJu/y1ZpZx34bCqpzFuM0VUO
         DFaPFXXp2aJxPEJb8JjjJObBxYpQQUa/LAgHRDWuEsbuSBObBk/l9yCHv0rygLNIXu9e
         3eYTP6BP4IpWgIopR9f24I4DpSFTMweTTMk/8=
Message-ID: <4DF65372.7090307@gmail.com>
Date: Mon, 13 Jun 2011 20:14:10 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <20110613164712.GA23343@srcf.ucam.org> <4DF64E6A.70700@gmail.com> <20110613180006.GA24902@srcf.ucam.org>
In-Reply-To: <20110613180006.GA24902@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 13-06-11 20:00, Matthew Garrett schreef:
> On Mon, Jun 13, 2011 at 07:52:42PM +0200, Maarten Lankhorst wrote:
>>> +		 */
>>> +
>>> +		if ((start <= virt_to_phys(_etext)-1 && end >= virt_to_phys(_text)) ||
>>> +		    (start <= virt_to_phys(_edata)-1 && end >= virt_to_phys(_etext)) ||
>> _etext -> _sdata perhaps?
> _etext is used for the resource allocation earlier, which seems like 
> it's probably the relevant thing to be copying.
I meant the second comparison, start <= edata && end >= _etext
>>>  		memblock_x86_reserve_range(start, start + size, "EFI Boot");
>>>  	}
>>>  }
>> Will test though. It might also be appropriate to put a WARN when that condition happens.
> That'd end up triggering even in cases that are absolutely safe (ie, the 
> firmware doesn't have this bug). The amount of suck here is incredible.
Still a crapload of swapper BUGs in free_init_pages, maybe you should just give up on this approach,
and call SetVirtualAddressMap before anything of importance runs. :-/

My kernel never needed the boot code hack btw, so I'm probably a terrible test subject for it.

~Maarten
