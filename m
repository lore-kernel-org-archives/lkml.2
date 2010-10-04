Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0JDNyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:54:24 -0400
Received: from core.signal11.us ([64.251.29.136]:35817 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0JDNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:54:23 -0400
Message-ID: <4CA9DC8D.3030207@signal11.us>
Date: Mon, 04 Oct 2010 09:54:21 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oliver@neukum.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
References: <1286018724-7484-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1286018724-7484-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Oct  4 09:54:22 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4ca9dc8e322831000621845
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2010 07:25 AM, Antonio Ospite wrote:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
> [...]
>
> This is reproducible by disconnecting the device while userspace does ioctl in
> a loop and doesn't check return values in order to exit the loop
>
> Should this be applied to older stable kernels too?
>
>    
This doesn't have anything to do with my patch really, and goes way 
back. I'd say yes, to every stable kernel which is still being maintained.

> Alan, Jiri,
>
> there is a similar problem when _writing_ to the device, but Alan's
> changes in that area are shuffling the code a bit, should I send a patch
> [to hidraw_send_report()] on top of Alan's work for that, or a fix for
> current mainline [in hidraw_write()] on which Alan should rebase his
> work would be better?
>    

This needs to go back into stable kernels as well, so a patch against 
mainline will be necessary for that. If you want to make a patch against 
mine, that's fine with me. If you want me to work it into my patch, 
that's fine too. (I want you to get credit for the fix though :) ).

> The same pattern of unchecked hidraw_table[minor] is also present in
> hidraw_get_report but this function is called only after the NULL check
> in hidraw_ioctl _for_now_, so that is currently safe.
>    

I can stick a comment ahead of hidraw_send_report, similar to the one 
which already exists.

Alan.


