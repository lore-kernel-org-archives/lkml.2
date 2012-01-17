Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab2AQFdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 00:33:07 -0500
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:50341 "EHLO
	homiemail-a43.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714Ab2AQFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 00:33:05 -0500
X-Greylist: delayed 105516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 00:33:05 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pcharlan.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=pcharlan.com;
	 b=NsDvZQG6jHlwoWNVuvoGpnsXW/Vsm8TrDBa3l+jeE9IfkLX5b+ZVl7HYqhGMc
	VGAihzq7O/YgjF8SFshYKvG7EDnUMlxduEEjrrYSvEhHeo/jWeQc5DK5EqVm4qRZ
	3ePLMCsyskiR+2lIhkjlnfIDjh/1YG1BndwITheAkZlJWM=
Message-ID: <4F15080C.6060004@pcharlan.com>
Date: Mon, 16 Jan 2012 21:33:00 -0800
From: Pete Harlan <pgit@pcharlan.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Junio C Hamano <junio@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: Re* Regulator updates for 3.3
References: <20120109073727.GF22134@opensource.wolfsonmicro.com> <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com> <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com> <20120110222711.GK7164@opensource.wolfsonmicro.com> <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com> <7vmx9v7z1r.fsf@alter.siamese.dyndns.org> <CA+55aFx5NATrpLnkMiV2vAxSAJPK7wkY2vyHbyeZGgT9+jP06w@mail.gmail.com> <7vehv77xeq.fsf@alter.siamese.dyndns.org> <CA+55aFzuGtJkQFDooSGWQ2_NiJVHN2E7S5dmOnWTYn8_s8Gg3g@mail.gmail.com> <7vzkdu7miv.fsf@alter.siamese.dyndns.org> <4F136BE4.4040502@pcharlan.com> <7v62gbussz.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7v62gbussz.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 03:33 PM, Junio C Hamano wrote:
> Pete Harlan <pgit@pcharlan.com> writes:
> 
>> On 01/10/2012 10:59 PM, Junio C Hamano wrote:
>>> There may be existing scripts that leave the standard input and the
>>> standard output of the "git merge" connected to whatever environment the
>>> scripts were started, and such invocation might trigger the above
>>> "interactive session" heuristics. Such scripts can export GIT_MERGE_LEGACY
>>> environment variable set to "yes" to force the traditional behaviour.
>>
>> The name GIT_MERGE_LEGACY gives no clue about what flavor of legacy
>> merge behavior is being enabled.  Something like GIT_MERGE_LEGACY_EDIT
>> might be clearer, or perhaps just have GIT_MERGE_EDIT=0 to get the old
>> behavior without reference to whether or not that behavior is
>> considered legacy.
> 
> Hrm.
> 
> The only case your suggestion may make a difference would be when we find
> another earlier UI mistake we would want to correct in a backward
> incompatible way that affects _existing_ scripts.
> 
> With your suggestion, they need to export "GIT_MERGE_EDIT=0" today, and
> they will need to update again to export "GIT_MERGE_SOMETHINGELSE=0" when
> such an incompatible change comes.

Which is a good thing, because maybe they started using Git after the
current proposed change (which they like), and what you see as new
becomes their "legacy" behavior.  If you change something after that,
you can't use GIT_MERGE_LEGACY=yes for that one also because which
legacy is it preserving?

In general, naming configuration variables "DO_IT_<THIS_WAY>" instead
of "DO_IT_THE_OLD_WAY" is better because it's self-documenting.  The
only time I think I'd prefer "LEGACY" is if you're planning on
deprecating and removing it eventually and you want to indicate
something to that effect in the name.

--
Pete Harlan
pgit@pcharlan.com
