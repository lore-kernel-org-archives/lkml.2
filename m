Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab0EZIrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:47:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:51917 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab0EZIrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OSaf27mS2IHrLa1GwoVAC2CF7lrQWIixYljbskUlCozuAxsYzOmQH5sMrVG6GQ2pbY
         HfLBHKGT0Io4WNRpBRv9xaEpmE3D+razbfoH/xOH2SmvK47M+1BMSVUG+1PUFgnZW9Dr
         jnfVIxNRY3/AXrAg/fTzzs19jcduxkQOMEHbc=
MIME-Version: 1.0
In-Reply-To: <4BFC0942.2030103@bfs.de>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<AANLkTik_QdZN_nFoOVD3-1JTGN5oxRySCdV5_eDqvQve@mail.gmail.com>
	<4BFBA3F2.2000301@bfs.de>
	<AANLkTilnueP5HIfX03soMCYE93jubL000rpiOCN1xB2-@mail.gmail.com>
	<4BFC0942.2030103@bfs.de>
Date: Wed, 26 May 2010 10:47:36 +0200
Message-ID: <AANLkTikeld4fbr9r1Sq0jhfkWxf0ZlwOsufUIRvb1rFH@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: wharms@bfs.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org
Cc: erik_list@caneris.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

==It seems LKML & netdev were dropped from the To list, re-adding==

Hi Walter,


>  if (ppp->rrsched % ppp->n_channels == i)
>
> since both do not change in that while() loop you can calculate in advance
> perhaps ppp->rrsched %= ppp->n_channels before the while ?
> (that would reduce my bad feels about variables that only increments also :)

rrsched and i do change when appropriate. As they are used as a cheap
way to get round robin, rrsched is not even initialized. One can argue
that this should be done, but as it literally does not matter where the
value starts counting....


> btw: you are doing  after loop() if(pch->chan == NULL) continue;
> that means the else in the if below  if (pch->chan) should never be reached.
> Or is it likely that some channel will be dropped (?) ?

Channels could be dropped and we need to guard against that.


> btw: this is intentional ? looks strange
>
>        if(ppp_ml_noexplode) {
> +       }
> +       else {

Leftover from various printks for debugging reasons.


Thanks for your feedback,
Richard
