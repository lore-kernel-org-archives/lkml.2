Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0ICUKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:10:48 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:34081 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab0ICUKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:10:46 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: Robert Hancock <hancockrwd@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: sata_sil24 memory fragmentation issues / VM allocation failures
Thread-Topic: sata_sil24 memory fragmentation issues / VM allocation failures
Thread-Index: AQHLS6QXYLvWJMLmG0yWLXJxAXcEUA==
Date: Fri, 3 Sep 2010 20:10:44 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282A527@Mercury.usurf.usu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.31.22.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I meant that "sata" is just the process name (I assume), it's not
> really anything to do with the SATA driver. Normally SATA host
> controller drivers don't really allocate memory at runtime so this
> wouldn't really be an issue with them. Network controllers do in order
> to handle received packets, though - it appears that for some reason
> the memory allocation by the network driver is failing.

You are correct - "sata" is the name of my SATA benchmarking app.  I had the same thought, so I went to the network driver and changed it so that it only ever dealt with single pages - the motivation being that if it only dealt with single pages I would never have a page allocation failure unless I was completely out of memory.  I made those changes and ended up seeing the same errors.

Someone did mention to me that the VM keeps an emergency reserve around for emergency allocations, so maybe I am hitting that barrier?

The thing that really gets me is that when I run the network alone or the disk alone there are no issues at all.  It is only when I run them together that I see problems.  I tried increasing how many packets I would handle in the polling function for the network, but that seemed to have zero effect.

> I'm not really sure why that is - it seems like you do have memory
> available. Hopefully some VM guru can pipe up with a suggestion.

That is what I am hoping as well.  Anyone have any thoughts?

