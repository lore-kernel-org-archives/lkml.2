Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab1CBVtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:49:42 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:36520
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810Ab1CBVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:49:41 -0500
Message-ID: <4D6EBB5A.7080307@gentoo.org>
Date: Wed, 02 Mar 2011 16:49:14 -0500
From: Kumba <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Can I nest kobjects to create directories under parent directories
 for my driver?
References: <4D6C68A4.3020306@gentoo.org> <20110302203823.GA18879@kroah.com>
In-Reply-To: <20110302203823.GA18879@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 15:38, Greg KH wrote:
>
> That's nice, but it really isn't a good idea to do things this deep.
> Userspace tools will not be able to find things properly (like libudev)
> and your kernel code will get very messy (as you have found out.)
>
> Why not look at how the other rtc drivers work, they don't nest things
> this deep and you need to sick with the standard userspace api and not
> invent a new one if at all possible.
>
> But to answer your question, you can do this, but I strongly discourage
> it.

 From the way sysfs seems to work, I can see that it encourages as little 
nesting as possible.  So this is probably the way I will go and just call the 
entries "regs_ctrla" through "regs_ctrl4b".  It still conveys the relevant 
information and is easily doable through the existing userspace framework.

How does one nest kobjects, though?  Are ksets the only real way?  Or is it 
doable through linking kobjects to each other?  If the latter is possible, how 
does one keep the reference to the device structure intact?  I figure the right 
use of backcasting (through container_of) is one way, but it definitely seems 
like I am treading new territory with such an approach.

I did learn one useful thing through this -- the use of a common show/store 
function for each register (using strncmp to look up which bit was accessed).  I 
was originally doing a single show/store pair for each, which added major code 
bloat and resulted in a ~80kb+ module.

Thanks for the feedback!  Thought my message had gotten lost!

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org

"The past tempts us, the present confuses us, the future frightens us.  And our 
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
