Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1GAN12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:27:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51028
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab1GAN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:27:24 -0400
Date: Fri, 1 Jul 2011 09:27:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 24/40] Staging: hv: storvsc: On I/O get the correct IDE
 device
Message-ID: <20110701132720.GA26825@infradead.org>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-24-git-send-email-kys@microsoft.com>
 <20110630194055.GC22707@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480816C2CF@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110701081725.GC28322@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480816C460@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816C460@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 01:01:43PM +0000, KY Srinivasan wrote:
> Nothing I could see from whatever testing I did. However, the guest will have
> Scsi hosts that the user did not configure. This is certainly the case in both 
> approaches - just the numbers are different!

If the IDE drivers were real IDE ones you'd also have one Scsi_Host for
each of the as that's how libata handles in.  In a way you're much
closer to real ATA than with the previous block driver.  If your host
side support the ATA passthrough SCSI cdbs you'll even be able to
pass taskfiles to them and use tools like hdparm in the guest.
