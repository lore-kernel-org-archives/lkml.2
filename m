Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0DTDWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:22:08 -0400
Received: from verein.lst.de ([213.95.11.210]:38789 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab0DTDWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:22:07 -0400
Date: Tue, 20 Apr 2010 05:22:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [2.6.34 regression] utsname.domainname not set in x86_32 processes
Message-ID: <20100420032200.GA13131@lst.de>
References: <20100419192147.GP11130@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419192147.GP11130@hexapodia.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 12:21:47PM -0700, Andy Isaacson wrote:
> 2.6.34-rc4 uname(2) from a x86_32 process copies out 325 bytes rather
> than the 390 bytes that 2.6.31 copied out (and that userland expects):

Which means we're missing exactly the domainname field in new_utsname,
which differenciates it from the old utsname structure.  Looks like we
end up calling the old uname sscall instead of the new one for some
reason. 

