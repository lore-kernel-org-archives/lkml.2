Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0JZCEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:04:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46864 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0JZCEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Sx564uvBe09UKbUTtzHdplsCYpoe2J8tdlRQdZ8mqY5gHmraKywineIKR/aoOt+WEt
         nGrmQYiuHeWNWcz5zhzazaurhq+X4cHYfKf4Mv+rKY8ef89ulCG8y/aI8fmpMqcfoZVE
         v32YCRmLnd/8PddJ0RrnThftoK2Vvgt0PHAu8=
Subject: Re: [PATCH 13/29] memstick: core: stop passing pointer to
 card->current_mrq
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <254156.53235.qm@web37608.mail.mud.yahoo.com>
References: <254156.53235.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:04:16 +0200
Message-ID: <1288058656.4024.129.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:41 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 13/29] memstick: core: stop passing pointer to card->current_mrq
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > This cleans up a lot of code and
> > makes the assumption
> > (*mrq == &card->current_mrq) official.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> Unfortunately, the description does not match the patch.
> While the main optimization (merging req and card arguments for good) is
> fully reasonable given the posterior knowledge of MSPro evolution, this
> patch introduces some functional changes as well, which can not be
> considered to be a pure cleanup. 
Agreed, some stuff slipped to that patch, will split.



> Some WARN_ONs also appear to be misplaced:
> 
> >         if (msb->block_req) {
> > -            mspro_block_complete_req(card, (*mrq)->error);
> > +            mspro_block_complete_req(card, mrq->error);
> >             error = mspro_block_issue_req(card, false);
> > 
> > -            if (!msb->block_req) {
> > +            if (error) {
> > +                WARN_ON(msb->block_req);
Nope that on purpose.
If mspro_block_issue_req returns error, the msb->block_req must be NULL.
 

Best regards,
	Maxim Levitsky

