Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2KMLFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:05:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41467 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2KMLFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:05:11 -0500
Date: Tue, 13 Nov 2012 11:04:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <rob.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Message-ID: <20121113110454.GE28341@n2100.arm.linux.org.uk>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <20121112192727.GB28341@n2100.arm.linux.org.uk> <CAF6AEGu4L+ukxhMBLYK3d2g4CBBXi6o5nN_wXvakZCT8qMfSEA@mail.gmail.com> <20121112230819.GC28341@n2100.arm.linux.org.uk> <CAF6AEGtLKjJ=BfBnOq+oE6cgneF5YqsbYqNnCPrz4sTFRzdibg@mail.gmail.com> <20121112235348.GD28341@n2100.arm.linux.org.uk> <CAF6AEGvoXR3YJomjV1YOeNvjr46aYJ2mVxS+jZfH+41+v1nAvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGvoXR3YJomjV1YOeNvjr46aYJ2mVxS+jZfH+41+v1nAvw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 06:31:50PM -0600, Rob Clark wrote:
> right, that is what I was worried about..  but what about something
> along the lines of:
> 
> 		case 8: {						\
> 			if (sizeof(x) < 8)				\
> 				__get_user_x(__r2, __p, __e, __l, 4);	\
> 			else						\
> 				__get_user_x(__r2, __p, __e, __l, 8);	\
> 			break;						\
> 		}							\
> 
> maybe we need a special variant of __get_user_8() instead to get the
> right 32bits on big vs little endian systems, but I think something
> roughly along these lines could work.

The problem with that is... big endian systems - where the 32-bit word we
want is the second one, so you can't just reduce that down to a 32-bit
access like that.  You also need to add an offset to the pointer in the BE
case (which can be done.)

I'd suggest calling the 4-byte version in there __get_user_xb() and doing
the 4-byte offset for BE inside that (or aliasing it to __get_user_x for
LE systems).
