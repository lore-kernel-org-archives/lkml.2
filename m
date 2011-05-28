Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab1E1CJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 22:09:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64085 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab1E1CJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 22:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X946KsD1Uzlrwy6KryHVJVPHlowjIAOpuyTe9aSHzJuoIdlaFtGP8kAuYnMroqyvp0
         ZYXonyCuF5o86DX8PY5mlX+JAZqfCTyzJcz7FF5q0f2iv/EQQ7AONne57af8s27Vz96c
         ouGLHs3iQigM1KCfUMUYcE/8WfM2EPPSmoHMc=
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20110527202747.GA4803@infradead.org>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
	 <20110527131237.GA27647@infradead.org>
	 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
	 <1306509182.1351.1.camel@leonhard> <4DE006C5.4010906@fusionio.com>
	 <20110527202747.GA4803@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 11:09:41 +0900
Message-ID: <1306548581.1679.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-27 (금), 16:27 -0400, Christoph Hellwig:
> On Fri, May 27, 2011 at 10:17:09PM +0200, Jens Axboe wrote:
> > Agree on Christophs comments, we should not pretend they are the same
> > (since they are not). Since flush is a request on its own, F works
> > nicely. For FUA it's associated with a write, so F should work there too
> > indicating Write Fua (and easily humanly parsed as that, or Write
> > Flush). WU would look confusing.
> 
> REQ_FLUSH can also be set on a write bio, it only gets split at the
> request level.  And even there we're at least pondering allowing it
> to stay as part of the write for some paravirtualized storage protocols.
> 

Hi,

AFAIK FLUSH always precedes WRITE and then followed by FUA, so how about
using the same F for both of them and distinguishing by position?

 - WRITE:            W
 - WRITE_FLUSH:      FW
 - WRITE_FUA:        WF
 - WRITE_FLUSH_FUA:  FWF

Or using lower-case 'f' for FUA?

Thanks.


-- 
Regards,
Namhyung Kim


