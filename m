Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1EaK12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:27:28 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48300 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1EaK1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HoP2Efmrx2q368cvnF9ELin+s2A7wSwMK6fuP5OJp9TdtDTqsqDIOf3b4ffXNFVKrK
         NvcZ1xX/5h9Otbl7+F+7D+FK6HbhCPf3Rn+zeBWb0qRqrVgk0ljNR1kb5ilrSuk9S96n
         ralpTzMDIOf+bAh/nsHr1VYZks8NsLvKSPYkI=
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20110528074449.GB22382@infradead.org>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
	 <20110527131237.GA27647@infradead.org>
	 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
	 <1306509182.1351.1.camel@leonhard> <4DE006C5.4010906@fusionio.com>
	 <20110527202747.GA4803@infradead.org> <1306548581.1679.12.camel@leonhard>
	 <20110528074449.GB22382@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 19:27:16 +0900
Message-ID: <1306837636.1464.15.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-28 (토), 03:44 -0400, Christoph Hellwig:
> On Sat, May 28, 2011 at 11:09:41AM +0900, Namhyung Kim wrote:
> > AFAIK FLUSH always precedes WRITE and then followed by FUA, so how about
> 
> Right now most do because that's how the old barriers worked, but it's
> going to change.  For $NEXT + 1 I have a patch that for will make
> xfs sends FUA without flushes in a lot of cases, and afaik some device
> mapper code already does now.
> 

OK, thanks for the explanation.

Btw, the point was it seems possible that we can use the 'F' for both
FLUSH and FUA if we distinguish them by their (relative) position in the
output. How do you think? Do you still prefer F/U flags?

Thanks.


-- 
Regards,
Namhyung Kim


