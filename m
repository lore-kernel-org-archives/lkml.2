Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750801Ab2LUFAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:00:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60438 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab2LUFAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:00:42 -0500
Message-ID: <50D3ECEB.1070401@zytor.com>
Date: Thu, 20 Dec 2012 21:00:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: new architectures, time_t __kernel_long_t
References: <201211141218.02105.arnd@arndb.de> <20121221045731.GO4939@ZenIV.linux.org.uk>
In-Reply-To: <20121221045731.GO4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 08:57 PM, Al Viro wrote:
> On Wed, Nov 14, 2012 at 12:18:01PM +0000, Arnd Bergmann wrote:
> 
>> The other types that are used as 64 bit on x32 are ino_t, nlink_t,
>> size_t, ssize_t, ptrdiff_t, and off_t.
> 
> *Kernel-side* we should not give a damn about the userland nlink_t, period.
> Making it architecture-dependent had been a bad mistake that essentially
> made nlink_t useless for the kernel.  That mistake had been fixed; please,
> do not bring it back.  If some userland structure needs to include a field
> encoding nlink_t values, please use an explicitly-sized type when refering
> to it kernel-side.
> 

We should never use userland types per se.  We can use __kernel_*_t
typedefs to make the kernel headers neater if it makes sense, but that
is often not even necessary.

> The same should've been true for mode_t, but for historical reasons we
> are using umode_t for just about everything and IMO we should kill the
> last references to mode_t anywhere kernel-side (again, explicitly-sized
> types for userland st_mode and friends on the last few architectures
> still refering to mode_t there) and just rename umode_t to mode_t; I'm
> sick and tired of playing whack-a-mole with code using (arch-dependent)
> mode_t for kernel data.  And no, it's not always harmless - we had rather
> ugly bugs based on that.
> 

