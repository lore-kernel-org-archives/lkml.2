Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1BBNaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:30:39 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58863 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab1BBNaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:30:39 -0500
X-Sasl-enc: pGaDQfK0Z9QsLVazn2hPrMOU+rcEjoz62I6IrN+lh5cw 1296653438
Date: Wed, 2 Feb 2011 11:30:36 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
Message-ID: <20110202133035.GF9737@khazad-dum.debian.net>
References: <20110202112139.GD14984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202112139.GD14984@redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Feb 2011, Gleb Natapov wrote:
> Check for nonzero path in edd_has_edd30() has no sense. First, it looks
> at the wrong memory. Device path starts at offset 30 of the info->params
> structure which is at offset 8 from the beginning of info structure, but
> code looks at info + 4 instead. This was correct when code was introduced,
> but around v2.6.4 three more fields were added to edd_info structure
> (commit 66b61a5c in history.git). Second, even if it will check correct
> memory it will always succeed since at offset 30 (params->key) there will
> be non-zero values otherwise previous check would fail.

Hmm, would that be a reason for boot lockups on some systems ?  I've
seen that happen on Intel D875PBZ and Debian stable (2.6.26).  We
dropped EDD support then.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
