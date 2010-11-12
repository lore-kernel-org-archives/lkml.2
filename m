Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0KLQ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:29:56 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:49056 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932533Ab0KLQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:29:55 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: wLK60k0VM1km.udh0QNrTfeiOK0SV8N2UYiPxyuazqjxSYv
 HWgjh51uKpsB5VRduYfaNX0HrttP7bgrlas4nepC.CVSE.TPN0DXTuu.ikHU
 BORLdg2gFj2w4JtBJBXf5PvbARPYueJxV89zOFJGInfmfT3WHgxpffKAecLP
 W3JDxq9xszigpaBVWizRXhKJTaaOM5.3n2AurwXjuoiGlGV3T51cJtnQgJwa
 R4aqOZ_syNnXN2yGVzVD5HicKr8ab
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 12 Nov 2010 10:29:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: Pekka Enberg <penberg@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH/RFC] MM slub: add a sysfs entry to show the calculated
 number of fallback slabs
In-Reply-To: <1289578964.1972.43.camel@castor.rsk>
Message-ID: <alpine.DEB.2.00.1011121028270.11746@router.home>
References: <1289561309.1972.30.camel@castor.rsk>  <alpine.DEB.2.00.1011120911310.11746@router.home> <1289578964.1972.43.camel@castor.rsk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Richard Kennedy wrote:

> I know it's not ideal. Of course there already is a counter in
> CONFIG_SLUB_STATS but it only counts the total number of fallback slabs
> issued since boot time.
> I'm not sure if I can reliably decrement a fallback counter when a slab
> get freed. If the size was changed then we could have slabs with several
> different sizes, and off the top of my head I'm not sure if I can
> identify which ones were created as fallback slabs. I don't suppose
> there's a spare flag anywhere.

There are lots of spare flags to be used for SLABs. We just decommissioned
the use of one SLUB_DEBUG. Look at the patchlist and revert that one
giving it a new name like SLUB_FALLBACK.

