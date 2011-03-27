Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1C0I4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 04:56:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64419 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1C0I4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 04:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TzrNcv4588jWbucyqHnar42YQ1dT3gqxoRaLN+pyYg6U83KY9A9ClOqeBwrH7cseHp
         lZZp9jE0q6mLg7229GOGJzynjVjkEn1OyO3KL6H0Vp4rcVGbvPEdFwaV0tlWf4wqTC++
         XZkpX2fpp08Xy7u+7lqxkR7hoy7FKP1tv3esM=
Subject: Re: [PATCH] x86: page: get_order() optimization
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, kernel-janitors@vger.kernel.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110323100757.GA14245@elte.hu>
References: <1300551947-22279-1-git-send-email-mcsim.planeta@gmail.com>
	 <20110323100757.GA14245@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 11:57:59 +0300
Message-ID: <1301216279.15393.9.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23/03/2011 at 11:07 +0100, Ingo Molnar wrote:

> Ok, that's certainly a nice optimization.

Thanks, I rewrote patch according to your observations.

> One detail: in many cases 'size' is a constant. Have you checked recent GCC, 
> does it turn the generic version of get_order() into a loop even for constants, 
> or is it able does it perhaps recognize the pattern and precompute the result?

Yes, gcc precomputes the result, so I added case for constants.

> With no #ifdefs in get_order().

And removed #ifdefs from get_order().

-- 
Thanks,

Maksym Planeta

