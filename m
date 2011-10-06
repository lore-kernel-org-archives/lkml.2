Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1JFKIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:08:35 -0400
Received: from [89.21.227.130] ([89.21.227.130]:57096 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755286Ab1JFKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:08:33 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 06:08:33 EDT
Message-ID: <4E8D7BFB.4070706@itdev.co.uk>
Date: Thu, 06 Oct 2011 10:59:23 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Joonyoung Shim <jy0922.shim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts - Use snprintf for sysfs attribute
 show method
References: <1316115647-1244-1-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1316115647-1244-1-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel-

Just to introduce myself, I'm working for Atmel in UK on the 
atmel_mxt_ts driver.

Daniel Kurtz wrote:
 > Sysfs attribute show methods are always passed a buffer of length
 > PAGE_SIZE.  To keep from overwriting this buffer and causing havoc,
 > use snprintf() to guarantee we never write more than the buffer can
 > hold.
 >
 > In addition, at least for my touchscreen, the number and size of
 > objects was far too big to fit in a single 4K page.  Therefore, this
 > patch also trims some redundant framing text to leave more room for
 > actual data.

Yes, I'd noticed this problem as well. I was planning to address it by 
splitting up the file, but your patch looks like a good solution for now.

I've tested it successfully on several chips.

Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>

-- 
Nick Dyer
Software Engineer, ITDev  Ltd

Hardware and Software Development Consultancy

Email:   nick.dyer@itdev.co.uk
Website: http://www.itdev.co.uk
