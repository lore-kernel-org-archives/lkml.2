Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2D3AgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:36:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab2D3AgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:36:00 -0400
Message-ID: <4F9DDE47.5060008@zytor.com>
Date: Sun, 29 Apr 2012 17:35:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com> <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com> <4F9DDCB6.1070908@zytor.com> <CA+55aFwGZm4+rdJ+xArhsVJ8P5gH3xxCfuoHibotr0Sik484=w@mail.gmail.com>
In-Reply-To: <CA+55aFwGZm4+rdJ+xArhsVJ8P5gH3xxCfuoHibotr0Sik484=w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 05:33 PM, Linus Torvalds wrote:
> 
> The problem is only if it starts out by reading just the header of the
> packet, and then reads the rest of the packet as a second read. *THAT*
> won't work with the packetized pipe approach, because reading the
> header of the packet will then discard the rest of it, and the second
> read would try to read the *next* packet (which under many normal
> loads won't even exist, of course).
> 

Which is funny/sad, because that's actually the intended way the
interface is meant to work.

	-hpa


