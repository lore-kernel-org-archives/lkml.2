Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0INQgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:36:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0INQf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:35:58 -0400
Date: Tue, 14 Sep 2010 18:29:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Message-ID: <20100914162952.GB13560@redhat.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
 <4C8F3C77.7010302@redhat.com>
 <1284476719.13351.35.camel@localhost.localdomain>
 <201009141721.13202.arnd@arndb.de>
 <20100914152231.GA13105@redhat.com>
 <1284480025.13351.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284480025.13351.49.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 09:00:25AM -0700, Shirley Ma wrote:
> On Tue, 2010-09-14 at 17:22 +0200, Michael S. Tsirkin wrote:
> > I would expect this to hurt performance significantly.
> > We could do this for asynchronous requests only to avoid the
> > slowdown. 
> 
> Is kiocb in sendmsg helpful here? It is not used now.
> 
> Shirley

Precisely. This is what the patch from Xin Xiaohui does.  That code
already seems to do most of what you are trying to do, right?

The main thing missing seems to be macvtap integration, so that we can fall back
on data copy if zero copy is unavailable?
How hard would it be to basically link the mp and macvtap modules
together to get us this functionality? Anyone?


-- 
MST
