Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307Ab2FEBIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:08:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60713 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761271Ab2FEBIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:08:10 -0400
Message-ID: <4FCD5BF3.30707@gmail.com>
Date: Tue, 05 Jun 2012 05:08:03 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why minor is still 8 bit?
References: <4FCC0E6D.9000206@gmail.com> <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com> <4FCCDE2B.3020306@schaufler-ca.com> <4FCD0591.2050504@gmail.com> <4FCD5869.8000306@zytor.com>
In-Reply-To: <4FCD5869.8000306@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2012 04:52, H. Peter Anvin wrote:
> On 06/04/2012 11:59 AM, George Shuklin wrote:
>> Very simple sample: I'd like to create shared storage to publish volumes
>> via ISCSI. ~60Tb of drives, ~2Gb average disk size = 30k disk images.
>> Can I just create a bunch of LV and export them by iet or scst? Nope:
>> There is a serious limit for amount of active LV per host. Yes, I can
>> create filesystem, put images (as file) to that filesystem and publish
>> them back, but why FS is needed to do such simple task?
> You realize that with that many volumes, a logical volume manager *is* a
> filesystem, right?
>
> 	-hpa

Well, I have nothing against filesystem with very small 'db-like' 
footprint: no directories, no attributes, extra-large allocation block, 
very fast initialization, no random file growth (very calm metadata 
without constant updating). If someone do have that type of FS (for disk 
images storage) - why not?

Anyway, using LVM to provide logical volumes to customers seems be fine 
(at least by name). But that limitation for minor is breaking whole idea.

I don't ask 'please fix', I'm just curious why so small?

