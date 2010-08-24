Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0HXR7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:59:54 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:42256 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932190Ab0HXR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:59:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oDorGm4VM1kjuHI.uWO8C2Io2jjpRetSDVckxWZmeheyBVo
 xleuvsk_ActtWfpnGexNVNIyY8EERfSYTbCo_ahGa9fLsfljx0nOugqJkCk8
 52fQyxXmo7HkSEIq6xoNARUjSdxHF2I1EMGk6nlvHDnCUGF88D2ciyGIHbf2
 8lc1zkK_wHldy_xtszBANjKkMSg4vZ0TXDz7HwXR7HDoe9or8ZU23Ekl1QA9
 6Iehlb.9NMB9OJJhoT3vxz4gDBWP3
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 24 Aug 2010 12:59:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <4C740450.3030000@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1008241256280.4763@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Pekka Enberg wrote:

> Thanks for the report. The problem should be fixed by this commit:

Its not that easy. __alloc_percpu falls back to kzalloc() on UP and this
can result in unique bootstrap problems with UP since the bootstrap array
is no longer there. Does the UP kernel boot?

Why did this ever build on my UP configuration tests? Hmmm... I only
tested x86_64 UP. This was 32 bit UP I guess.




