Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab2CTNvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:51:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2CTNvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <1332245223.3329.5.camel@jlt3.sipsolutions.net>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
 <1332214021-9716-3-git-send-email-mcgrof@frijolero.org> <1332245223.3329.5.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Mar 2012 06:50:44 -0700
X-Google-Sender-Auth: rmenNELNR4Vl4Qx6JX_iEutlS9M
Message-ID: <CAB=NE6V4NuNc8Xr3qKAaXgs2og-2e6qusek=ZFdvQCq4JtKavQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] compat: backport work_busy()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 5:07 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-03-19 at 20:26 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
>>
>> Best we can do is just tell the users of we are WORK_BUSY_PENDING
>> for older kernels. The ckmake log:
>
> [...]
>
>> + * Test whether @work is currently pending or running.  There is no
>> + * synchronization around this function and the test result is
>> + * unreliable and only useful as advisory hints or for debugging.
>> + * Especially for reentrant wqs, the pending state might hide the
>> + * running state.
>
> What's this needed for? It seems if it's used only for hints/debugging
> we should not need the function, or possibly simply return some
> pointless combination like -1?

net/bluetooth/hci_core.c:1701:	if (work_busy(&hdev->le_scan))

  Luis
