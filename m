Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab1BJUhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:37:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:54281 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab1BJUhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:37:50 -0500
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
From: James Bottomley <James.Bottomley@suse.de>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1297366384.2645.175.camel@schen9-DESK>
References: <1297300864.2645.128.camel@schen9-DESK>
	 <1297359914.4933.56.camel@mulgrave.site>
	 <1297366384.2645.175.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 14:37:43 -0600
Message-ID: <1297370263.4933.74.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 11:33 -0800, Tim Chen wrote:
> On Thu, 2011-02-10 at 11:45 -0600, James Bottomley wrote:
> 
> > 
> > What you say is true as long as the value is 32 bits ... perhaps a note
> > of that should be made somewhere?
> > 
> 
> It seems like pm_qos_add_request, pm_qos_update_request only uses 32
> bits value.  Did I miss some cases where the target value for
> pm_qos_object be non-32 bit under some situation?

No ... I'm thinking of the future.  On the face of it, if we needed
larger quantities (like s64), the obvious approach would be to change
s32 to s64 which would fail ... horribly.  I was just suggesting a nice
reminder comment for this.

James


