Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2LILzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:55:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47742 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab2LILzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:55:20 -0500
Date: Sun, 9 Dec 2012 12:55:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aaron Williams <Aaron.Williams@cavium.com>
Cc: linux-kernel@vger.kernel.org,
        "Williams, Aaron" <Aaron.Williams@caviumnetworks.com>
Subject: Re: Incrementing module reference count
Message-ID: <20121209115517.GA27330@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Aaron Williams <Aaron.Williams@cavium.com>,
	linux-kernel@vger.kernel.org,
	"Williams, Aaron" <Aaron.Williams@caviumnetworks.com>
References: <50C2947F.5030706@cavium.com>
 <20121208114453.GC11662@liondog.tnic>
 <50C3924B.1050300@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C3924B.1050300@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 11:17:31AM -0800, Aaron Williams wrote:
> I got it working. I designed my solution to be generic so it's not
> tied to just the at24 driver. I added a memory accessor module which
> is basically a registry. The at24 driver registers with it and then
> the Vitesse PHY driver calls it to gain access to the at24 driver.
> Only when the Vitesse driver gets the memory accessor the reference
> count for the at24 driver is incremented.

Hmm, I'm not sure you even need an additional layer because there's also
request_module(). And as long as your module is using at24, you won't
need to increment its refcount, AFAICT.

HTH.

-- 
Regards/Gruss,
    Boris.
