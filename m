Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab0JLGuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:50:25 -0400
Received: from canuck.infradead.org ([134.117.69.58]:54050 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab0JLGuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:50:24 -0400
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286865923.7768.188.camel@yhuang-dev>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-3-git-send-email-ying.huang@intel.com>
	 <1286813635.2336.617.camel@twins>  <1286844650.7768.137.camel@yhuang-dev>
	 <1286863479.2336.1451.camel@twins>  <1286864080.7768.179.camel@yhuang-dev>
	 <1286865071.2336.1478.camel@twins>  <1286865447.7768.184.camel@yhuang-dev>
	 <1286865629.2336.1490.camel@twins>  <1286865923.7768.188.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 08:49:53 +0200
Message-ID: <1286866193.2336.1503.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 14:45 +0800, Huang Ying wrote:
> On Tue, 2010-10-12 at 14:40 +0800, Peter Zijlstra wrote:
> > On Tue, 2010-10-12 at 14:37 +0800, Huang Ying wrote:
> > > I just think two die_value make order more explicit. 
> > 
> > I think it sucks, you get to iterate the list twice for no gain.
> 
> The gain is the code readability. And maybe we can split the list into 2
> in the future.

No, its not making sense, there's only one event source - the NMI, it
doesn't make any sense what so ever to then artificially split it in
two.


