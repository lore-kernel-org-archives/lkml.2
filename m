Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1CLMly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 07:41:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48941 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1CLMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 07:41:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UhAsaxGB9jnH4f9998u86hDSo5hx2byQL1dc54BPoBT7II4F7E7YZizBSpO68ep3iq
         VUoJy++f6XAaC6Hg6qNnzQ2uYVH78InshCUOtFGREFDyQYbbf3cRq5dSBSmnB/nLTLqW
         U7JyhVMSXnl4hPZV9q3J1RE9g4TzHADdD31Ew=
Message-ID: <4D7B6A03.9040900@gmail.com>
Date: Sat, 12 Mar 2011 07:41:39 -0500
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>    <201103111255.44979.arnd@arndb.de>    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>    <4D7AC0FE.8070806@gmail.com>    <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>    <4D7ADFDD.9080108@gmail.com> <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
In-Reply-To: <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 10:50 PM, Indan Zupancic wrote:
> On Sat, March 12, 2011 03:52, Ric Wheeler wrote:
>> Sage was pretty clear in stating the motivation which is the use case you
>> think is questionable. Probably not interesting for consumer devices, but
>> definitely extremely interesting in large servers with multiple file systems.
> Not really, he just said "It is frequently useful to sync a single file system",
> without giving any use cases. He then gave two situations where either sync or
> fsync isn't sufficient, to which I replied earlier and you called missing the
> point. But that's not the same as giving a use case.
>
>> In fact, we do it today as mentioned earlier in the thread - this simply
>> exports that useful capability in a clean way.
> Did you use the remount trick or the ioctl? If the latter, is it sufficient
> for your need? If the first, would guaranteeing that mount -o remount,rw
> trick will keep working solve the problem for you?
>
> When or why would you want to sync one specific filesystem? As you're doing
> it, you could explain your use case better instead of telling me I'm missing
> the point.
>
> If sync(2) didn't exist and people wanted to add it I'd complain too. This
> has all the problems of sync(2), but with the "not sure if all the files are
> on the file system I think" problem added.
>
> Greetings,
>
> Indan

System wide sync and file system specific sync are useful in several scenarios. 
One example is something like a restore (or an rsync) where an application 
copies lots of files into a target file system. It is *much* faster to do this 
without doing an fsync() call per file (orders of magnitude faster).

Once your bulk write has finished, it is prudent to run "sync" to push that data 
out to disk before you trust that your new copy will survive a crash or power 
outage. Alternatively, you could reopen and fsync each file that was copied 
which seems to be the method that you prefer.

Ric

