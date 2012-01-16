Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2APXdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:33:05 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:58268 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2APXdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:33:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=FWPginPHV86PAQie3B+SHF+6YBdWkDxM
	e8TnCQRBI4uu0ME4aA9jf0ZqQUBwxv4hJmgJFEtPUwLWDhtxmyOVO1zpA7HJglM5
	0rjjKXNLtbIxsJZcaGWd0+SrE566Tn40E6ApRJ21YpboAjTy+jxPeyajjEKf8TdM
	Ge4U4SpEZio=
From: Junio C Hamano <junio@pobox.com>
To: Pete Harlan <pgit@pcharlan.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: Re* Regulator updates for 3.3
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com>
 <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com>
 <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <7vmx9v7z1r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx5NATrpLnkMiV2vAxSAJPK7wkY2vyHbyeZGgT9+jP06w@mail.gmail.com>
 <7vehv77xeq.fsf@alter.siamese.dyndns.org>
 <CA+55aFzuGtJkQFDooSGWQ2_NiJVHN2E7S5dmOnWTYn8_s8Gg3g@mail.gmail.com>
 <7vzkdu7miv.fsf@alter.siamese.dyndns.org> <4F136BE4.4040502@pcharlan.com>
Date: Mon, 16 Jan 2012 15:33:00 -0800
In-Reply-To: <4F136BE4.4040502@pcharlan.com> (Pete Harlan's message of "Sun,
 15 Jan 2012 16:14:28 -0800")
Message-ID: <7v62gbussz.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 6E3BF7DC-409A-11E1-AE25-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Harlan <pgit@pcharlan.com> writes:

> On 01/10/2012 10:59 PM, Junio C Hamano wrote:
>> There may be existing scripts that leave the standard input and the
>> standard output of the "git merge" connected to whatever environment the
>> scripts were started, and such invocation might trigger the above
>> "interactive session" heuristics. Such scripts can export GIT_MERGE_LEGACY
>> environment variable set to "yes" to force the traditional behaviour.
>
> The name GIT_MERGE_LEGACY gives no clue about what flavor of legacy
> merge behavior is being enabled.  Something like GIT_MERGE_LEGACY_EDIT
> might be clearer, or perhaps just have GIT_MERGE_EDIT=0 to get the old
> behavior without reference to whether or not that behavior is
> considered legacy.

Hrm.

The only case your suggestion may make a difference would be when we find
another earlier UI mistake we would want to correct in a backward
incompatible way that affects _existing_ scripts.

With your suggestion, they need to export "GIT_MERGE_EDIT=0" today, and
they will need to update again to export "GIT_MERGE_SOMETHINGELSE=0" when
such an incompatible change comes.

With a single "GIT_MERGE_LEGACY=YesPlease", they can be future-proofed today
and will not be affected when we make another incompatible change.

So I am not sure why separating the big-red-switch into smaller pieces
would be an improvement, especially wnen the scripts that want to specify
finer-grained control of features can use "--[no-]edit" options to
explicitly ask for it.

