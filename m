Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1HKT7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:59:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1HKT73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:59:29 -0400
Message-ID: <4E44349D.9030809@profitbricks.com>
Date: Thu, 11 Aug 2011 21:59:25 +0200
From: Dongsu Park <dongsu.park@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110627 Thunderbird/5.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Liu Yuan <namei.unix@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <1311863346-4338-2-git-send-email-namei.unix@gmail.com> <20110728152244.GA31888@redhat.com>
In-Reply-To: <20110728152244.GA31888@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/28/2011 05:22 PM, Michael S. Tsirkin wrote:
> On Thu, Jul 28, 2011 at 10:29:05PM +0800, Liu Yuan wrote:
>> +static struct miscdevice vhost_blk_misc = {
>> +	234,
>
> Don't get a major unless you really must.

the minor number 234 conflicts with that of BTRFS, in kernel 3.0 at least.
Therefore you cannot load vhost_blk.ko if btrfs.ko was already loaded.
Probably that number should be something else, with which you don't have 
conflict with any minor number in include/linux/miscdevice.h.

-- 
Dongsu Park
Email: dongsu.park@profitbricks.com
