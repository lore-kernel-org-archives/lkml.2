Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1JQVnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:43:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43334 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1JQVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:43:31 -0400
Date: Tue, 18 Oct 2011 06:43:27 +0900
From: Mattia Dongili <malattia@linux.it>
To: John Hughes <john@calvaedi.com>
Cc: Valdis.Kletnieks@vt.edu, John Hughes <john@Calva.COM>,
        linux-kernel@vger.kernel.org, Stelian Pop <stelian@popies.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
Message-ID: <20111017214326.GA1311@kamineko.org>
References: <4E9ABBF6.3000504@calvaedi.com>
 <4E9ADBD3.4070404@calvaedi.com>
 <4E9B182A.3020101@calvaedi.com>
 <74494.1318789218@turing-police.cc.vt.edu>
 <20111016213800.GA12703@kamineko.org>
 <81436.1318801813@turing-police.cc.vt.edu>
 <4E9B65EC.7020303@calvaedi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9B65EC.7020303@calvaedi.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.1.0-rc4+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 01:17:00AM +0200, John Hughes wrote:
> On 10/16/2011 11:50 PM, Valdis.Kletnieks@vt.edu wrote:
> >
> >And let me guess - two phase hotkey decoding is sufficiently weird that
> >nobody wants to actually fix *that* code, right? (Rhetorical question, I
> >already know the answer to that one).
> Ok, what is "two phase hotkey decoding?"

basically the driver receives in IRQ, reads from the IO port a value
that turns out to be a generic value that means "got a hotkey" and needs
to write one more command to the IO port and wait for another IRQ that
potentially has the information about what hotkey was pressed.

The part we're currently missing is what to write to the IO port for
some models.

See type3_handle_irq in the source and type3_events: most of those with
data=0x05 require extra handling that we are not doing. 
On the second IRQ you get some data=0x31 and the actual event.

Hope it's clearer.
-- 
mattia
:wq!
