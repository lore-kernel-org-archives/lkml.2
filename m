Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1ATTtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:49:02 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:52030 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750768Ab1ATTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:49:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=leZZNvcKKG/oI3Cbz90PDdZmRw8hQgClW9zIzO1e4K7G73boY/RHdluBjk5kZ+1/3/8qyUhQfAFAILYvrL2fkCjz5Vq64IsaAJ6q59N/1y9mn/JqeXrY7qppxp6bWkjT;
Date: Thu, 20 Jan 2011 11:42:16 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Cc: <sfr@canb.auug.org.au>, "Arnd Bergmann" <arnd@arndb.de>, <gregkh@suse.de>,
        <dmitry.torokhov@gmail.com>, <dtor@mail.ru>, <rubini@cvml.unipv.it>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: Request for unicore32 architecture codes to merge into
 linux-next
Message-ID: <20110120114216.4b23182a@jbarnes-desktop>
In-Reply-To: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011 01:00:31 +0800
"Guan Xuetao" <guanxuetao@mprc.pku.edu.cn> wrote:

> Hi,
> 
> I want to merge unicore32 repo into linux-next tree, the position is (unicore32 branch):
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---

Took a quick look at the PCI parts, looks like you have a pretty big
DMA restriction.

You could provide your own dma map ops and make the allocator a bit
smarter about where it gets memory (preferentially allocating from the
DMA'able region, which you could hide).  Or do you find that swiotlb
does ok in general?

Other than that you had pretty tiny bits of enabling code, I assume
they work on your platform (config space access & setup, etc.).

-- 
Jesse Barnes, Intel Open Source Technology Center
