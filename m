Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab2DBJ33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:29:29 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40484 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751056Ab2DBJ32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:29:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC] net: bpf_jit: Two pass JIT and other changes
Date: Mon, 2 Apr 2012 10:28:07 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6ECF@saturn3.aculab.com>
In-Reply-To: <5185e05a69d88b5f12b5656358745b1a.squirrel@webmail.greenhost.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] net: bpf_jit: Two pass JIT and other changes
Thread-Index: Ac0PN3BDP5gdxfDRQXiy5Fpogd2ZQQBetopw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Indan Zupancic" <indan@nul.nu>, "Eric Dumazet" <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Apr 2012 09:28:07.0283 (UTC) FILETIME=[E9971C30:01CD10B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 1) Sadly, gcc isn't always smart enough to inline emit_code().
>    So turn it into a macro to force gcc to inline it. This saves
>    about 500 bytes. Tested with gcc 4.6.0. An alternative to the
>    macro would be to create inline emit_code1(), emit_code2() etc.

Does giving it the __attribute__((always_inline)) help?
I had to mark a load of small static functions that way
after a minor change (possibly to the overall size)
stopped gcc inlining everything.

I have also noticed in the past that gcc tends to generate
better code for #define than when inlining functions.

	David


