Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1AAQvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 11:51:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41453 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1AAQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 11:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=iCAUD+KnLHH5ABqmLg13wzbr3PXkfLy/YgM+wlEsHSZ+OySxcHiLrVdbnWxYcYbehb
         hYFm6kOE5ALi+jinvedYZdu8MJQb/iPYMMrnZ0sJ4K0R0sM+WbhMCiDqnEMiDlZ1j8+h
         jljroZMRyVCII7kzQwtRcdC5W0K4Kyro1wj/4=
Date: Sat, 1 Jan 2011 19:51:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, balbir@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
Message-ID: <20110101165135.GJ1886@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>, balbir@linux.vnet.ibm.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4D1BCE58.4000902@suse.com>
 <20101229161418.d34bf0d4.akpm@linux-foundation.org>
 <4D1C180A.20000@suse.com>
 <20101229213243.891b0db5.akpm@linux-foundation.org>
 <4D1CAAA1.8030106@suse.com>
 <20110101171946.6179c3b6@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110101171946.6179c3b6@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 01, 2011 at 05:19:46PM +0100, Florian Mickler wrote:
> Is there already a patch available or integrated into iotop which
> fixes this? I'd think that if the kernel could wait on fixed iotop's to
> be distributed it would be easier to sell the breakage on bugzilla &
> co...
> 

The story is that 4be2c95d1f "taskstats: pad taskstats netlink response
for aligment issues on ia64" broke iotop on 64 bit processors (32 bit
was unaffected).  This patch fixes it for x86-64 and powerpc-64.

On the other 64 bit processors iotop works but instead you get a message
in dmesg:
kernel unaligned access to 0xe000023879dca9bc, ip=0xa000000100133d10

So on those arches you were already getting posts to bugzilla etc.  Now
those people can upgrade the kernel and download iotop version 0.4.2 or
higher.

regards,
dan carpenter

