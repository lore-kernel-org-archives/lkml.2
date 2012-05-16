Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab2EPV6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:58:52 -0400
Received: from kanga.kvack.org ([205.233.56.17]:48092 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2EPV6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:58:50 -0400
Date: Wed, 16 May 2012 17:58:49 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120516215849.GC32221@kvack.org>
References: <20120515133450.GD22985@linux.intel.com> <1337149453.1961.24.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337149453.1961.24.camel@slavad-ubuntu-11>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:24:13AM +0400, Vyacheslav Dubeyko wrote:
> Could you please share vision of these NVM technologies in more details?
> What capacity in bytes of of one NVM unit do we can expect? What about
> bad blocks and any other reliability issues of such NVM technologies?
> 
> I think that some more deep understanding of this can give possibility
> to imagine more deeply possible niche of such NVM units in future memory
> subsystem architecture.

Try having a look at the various articles on ReRAM, PRAM, FeRAM, MRAM...  
There are a number of technologies being actively developed.  For some 
quick info, Samsung has presented data on an 8Gbit 20nm device (see 
http://www.eetimes.com/electronics-news/4230958/ISSCC--Samsung-preps-8-Gbit-phase-change-memory ).  
It's hard to predict who will be first to market with a real production 
volume product, though.

The big question I have is what the actual interface for these types of 
memory will be.  If they're like actual RAM and can be mmap()ed into user 
space, it will be preferable to avoid as much of the overhead of the existing 
block infrastructure that most current day filesystems are built on top of.  
If the devices have only modest endurance limits, we may need to stick the 
kernel in the middle to prevent malicious code from wearing out a user's 
memory cells.

		-ben

