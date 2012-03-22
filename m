Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031109Ab2CVRCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:02:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42620 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031000Ab2CVRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:02:27 -0400
Message-ID: <4F6B5B1E.9090402@suse.cz>
Date: Thu, 22 Mar 2012 18:02:22 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Slaby <jirislaby@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
References: <cover.1331856299.git.joe@perches.com>  <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>  <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>  <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>  <4F684673.1050309@suse.cz> <1332235315.7847.63.camel@joe2Laptop>  <4F684D00.4040102@suse.cz> <1332236803.7847.85.camel@joe2Laptop>
In-Reply-To: <1332236803.7847.85.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 10:46 AM, Joe Perches wrote:
> On Tue, 2012-03-20 at 10:25 +0100, Jiri Slaby wrote:
>> On 03/20/2012 10:21 AM, Joe Perches wrote:
>>> the ath5k pr_ conversion patches are to
>>> standardize prefixes and to reduce code size by
>>> centralizing tests.
>>
>> What is the "standard" prefix?
> 
> KBUILD_MODNAME

Instead, we should switch as many printks to dev_* and similar as
possible, right? They are standard and provide a good interface for
extensions: one has a device to work with. This is something what pr_*
does not offer. For that reason it's not worth it.

>>> https://lkml.org/lkml/2012/3/18/121
>>> https://lkml.org/lkml/2012/3/18/123
>>> https://lkml.org/lkml/2012/3/18/124
>>> I happen to like 30K/10+% code size reductions.
>> Obvious question: what speed reduction does this bring?
> 
> Anyone looking for speed impacts in logging
> messages is looking in the wrong place.

Ok, I finally found some time to look into the changes properly. I was
confused by Adrian's note that you moved a debug check to an external
function. But that is not true.

> btw: it's effectively 0.

Frankly, moving the debug code to a separate function should make the
code rather faster. By moving the unlikely code out of the instruction
cache.

thanks,
-- js suse labs


