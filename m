Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2DRUwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:52:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44071 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2DRUwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:52:31 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.84.216]
In-Reply-To: <87y5pskiis.fsf@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<1332173578-27422-8-git-send-email-j-pihet@ti.com>
	<87y5pskiis.fsf@ti.com>
Date: Wed, 18 Apr 2012 22:52:31 +0200
Message-ID: <CAORVsuXup38v0qhSSm7oeo5uzBN-Kd9T91_Zi4mtY_CG6L_QsA@mail.gmail.com>
Subject: Re: [PATCH 7/9] ARM: OMAP2+: SmartReflex: Use per-OPP data structure
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Thara Gopinath <thara@ti.com>, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 8:21 PM, Kevin Hilman <khilman@ti.com> wrote:
> jean.pihet@newoldbits.com writes:
>
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> The SmartReflex driver incorrectly treats some per-OPP data as data
>> common to all OPPs (e.g., ERRMINLIMIT).  Move this data into a per-OPP
>> data structure.
>
> OK
>
>> The SmartReflex driver should not be dependent on whether the host SoC
>> uses eFuses to store SmartReflex parameters or not.  (Even SoCs that
>> do store SR data in eFuses often need to override that data with
>> software-defined values.)  So, convert sr_retrieve_nvalue() to look up
>> per-OPP data by the OPP's nominal voltage, rather than by the eFuse
>> offset.
>
> Right.
>
>> While at it:
>>  . tidy up the code wrt default values in the data tables,
>>  . remove the global errminlimit debugfs entry and create per-voltage
>>    entries from the data tables.
>
> OK
>
>> Furthermore, in order to make the SmartReflex implementation ready for
>> the move to drivers/, remove the dependency from the SR driver code
>> to the voltage layer by querying the data tables only from the SR device
>> init code.
>
> So that's 4 relatively independent things going on in this patch which
> makes it somewhat difficult to review and understand.
>
> I'd suggest breaking it up into smaller parts if possible.  If not, fix
> up the changelog to describe why all of these need to go together, and
> why it's necessary to do them before the move.
Those changes are not independent from each other.
However for improved readability the patch can be split up (e.g.
efuse->opp, debugfs ...) and the changelog updated accordingly.

>
> Thanks,
>
> Kevin
>

Thanks,
Jean
