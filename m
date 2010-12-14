Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab0LNRAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:00:36 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:51347 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650Ab0LNRAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eerAxLdmPkQCCRUMuNEsHbaRpQJ6ITvFQmXFFuB5eWD4xz2QWahMajYDHuvbmMzVB6
         0wGVGunurtl4UCbiqyDB/bAED29rt7vAGKS0+GA/mgjtn730LEfEvLTh0f5RUpAauocu
         Wca5N6OY/oP3CAg5MbbNi8hb7qEmjUSBTJBgc=
Date: Tue, 14 Dec 2010 09:00:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Synaptics touchpad on Dell Vostro V13
Message-ID: <20101214170027.GA11318@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1012141547570.15140@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012141547570.15140@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 03:56:56PM +0100, Jiri Kosina wrote:
> Hi Dmitry,
> 
> I have a bugreport about Synaptics touchpad not working as proper 
> Synaptics, but only being detected as standard PS/2.
> 
> Looking at the i8042.debug output, the device is clearly buggy, as it 
> doesn't identify itself by 0x47 when queried:
> 
> 	91 -> i8042 (command) [58]
> 	e8 -> i8042 (parameter) [58]
> 	fa <- i8042 (interrupt, 3, 12) [59]
> 	91 -> i8042 (command) [59]
> 	00 -> i8042 (parameter) [59]
> 	fa <- i8042 (interrupt, 3, 12) [59]
> 	91 -> i8042 (command) [59]
> 	e8 -> i8042 (parameter) [59]
> 	fa <- i8042 (interrupt, 3, 12) [60]
> 	91 -> i8042 (command) [60]
> 	00 -> i8042 (parameter) [60]
> 	fa <- i8042 (interrupt, 3, 12) [61]
> 	91 -> i8042 (command) [61]
> 	e8 -> i8042 (parameter) [61]
> 	fa <- i8042 (interrupt, 3, 12) [61]
> 	91 -> i8042 (command) [61]
> 	00 -> i8042 (parameter) [61]
> 	fa <- i8042 (interrupt, 3, 12) [62]
> 	91 -> i8042 (command) [62]
> 	e8 -> i8042 (parameter) [62]
> 	fa <- i8042 (interrupt, 3, 12) [63]
> 	91 -> i8042 (command) [63]
> 	00 -> i8042 (parameter) [63]
> 	fa <- i8042 (interrupt, 3, 12) [64]
> 	91 -> i8042 (command) [64]
> 	e9 -> i8042 (parameter) [64]
> 	fa <- i8042 (interrupt, 3, 12) [64]
> 
> ... and here we time out after approximately 0.5s. nomux doesn't really 
> fix it, we start getting a lot of timeouts on i8042 with that.
> 
> Apparently the device works with Synaptics driver in Other OS(TM) though. 
> Do you have any idea what they might be doing differently so that they 
> make the touchpad identify itself properly?

Hi Jiri,

Do you have the device in your possession? If so can you check if the
driver installed in Other OS uses active multiplexing? I think you can
infer whether it does or not by looking at the pointer properties - I
think it would "Synaptics Blah at port X" or something like that...

Also you could try combining nomux with reset and see if it makes any
sense...

Thanks.

-- 
Dmitry
