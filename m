Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408Ab2JXQJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:09:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56758 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2JXQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:09:17 -0400
Message-ID: <5088111F.1020009@gmail.com>
Date: Wed, 24 Oct 2012 18:02:39 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] procfs: drop vmtruncate
References: <5082965D.3070307@gmail.com> <20121024151208.GB24318@infradead.org>
In-Reply-To: <20121024151208.GB24318@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/10/2012 17:12, Christoph Hellwig ha scritto:
> On Sat, Oct 20, 2012 at 02:17:33PM +0200, Marco Stornelli wrote:
>> Removed vmtruncate
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>
> As Al pointed out we probably shouldn't even allow truncate on procfs.
> Can look into refusing it instead, please?
>
>

Mmmm...for example the command "truncate --size=100 config.gz" is a nop, 
so it seems to me it makes no sense to support the size change, but I 
don't know if there are other use cases. However, should we return EPERM 
in case of size change checking it before inode_change_ok()?

Marco
