Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab1CNBiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:38:08 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44423 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab1CNBiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:38:03 -0400
Message-ID: <3cc2c5c6fa6b3bd384017ae95a4241ab.squirrel@webmail.greenhost.nl>
In-Reply-To: <1299957736.2332.4.camel@koala>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <4D7AC0FE.8070806@gmail.com>
    <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
    <1299957736.2332.4.camel@koala>
Date: Mon, 14 Mar 2011 02:38:01 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: dedekind1@gmail.com
Cc: "Ric Wheeler" <ricwheeler@gmail.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "Sage Weil" <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Jonathan Nieder" <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 9090f8a1960d7f777b94d17b6f36e747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, March 12, 2011 20:22, Artem Bityutskiy wrote:
> On Sat, 2011-03-12 at 02:33 +0100, Indan Zupancic wrote:
>> > I think that you missed the point of the extension.
>> >
>> > Ric
>>
>> The point is clear, it's to synchronize a specific file system instead
>> of all of them.
>>
>> But actually doing that from a program is harder than it looks, because
>> programs work with files, not file systems. To make this feature useful
>> the program needs meta information it can't easily get. That was my first
>> point.
>
> I had a program, actually a set of programs, which test a file-system.
> And this set of programs needed such a feature quite a lot, to sync the
> FS which is being tested and nothing else - for both performance reasons
> and to put more stress to the FS under testing. We used -o remount, rw
> for this - but this forced us to run under root.

You could use a tiny setuid root helper binary that does the remount trick.

> IOW, there are programs which take a mount point as an input parameter
> and want do things with the whole FS, not only individual files.

And those probably need to mount or unmount the FS at one point or the
other, or can use the setuid helper binary.

If you want to add syncfs, at least ad it together with BSD so it's slightly
portable.

Greetings,

Indan


