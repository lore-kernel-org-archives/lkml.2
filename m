Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2B2NCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:02:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35416 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749Ab2B2NCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:02:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of julian.calaby@gmail.com designates 10.50.181.165 as permitted sender) smtp.mail=julian.calaby@gmail.com; dkim=pass header.i=julian.calaby@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWngBAx4TRqW3sJ9EUEGW=YFgRD3vcqHMatWsyB=oDTOg@mail.gmail.com>
References: <CAFxU49m76xaLGv9CFhKcZBhE-8QgT1KSuhnZRcVwzP2ogrGpbQ@mail.gmail.com>
 <CAGRGNgWngBAx4TRqW3sJ9EUEGW=YFgRD3vcqHMatWsyB=oDTOg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 1 Mar 2012 00:02:27 +1100
Message-ID: <CAGRGNgV5vmLptT5mFCs02xD_6+SxqO25BA2e67kH6_mcNhi-8w@mail.gmail.com>
Subject: Re: [PATCH] mac80211: improve PID rate control mechanism by avoiding
 rate oscillation problem
To: YIN Wei <yinwei168@gmail.com>
Cc: johannes <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, mattias.nissler@gmx.de,
        stefano.brivio@polimi.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yin,

One final thing:

On Wed, Feb 29, 2012 at 23:59, Julian Calaby <julian.calaby@gmail.com> wrote:
>> @@ -318,22 +578,61 @@ rate_control_pid_rate_init(void *priv, s
>>                        rinfo[i].diff = i * pinfo->norm_offset;
>>        }
>>        for (i = 1; i < sband->n_bitrates; i++) {
>> -               s = false;
>> +               s = 0;
>
> Why are you using integers with a boolean variable?
>
>>                for (j = 0; j < sband->n_bitrates - i; j++)
>>                        if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
>> -                                    sband->bitrates[rinfo[j + 1].index].bitrate)) {
>> +                               sband->bitrates[rinfo[j + 1].index].bitrate)) {

This whitespace change should be dropped.

>>                                tmp = rinfo[j].index;
>>                                rinfo[j].index = rinfo[j + 1].index;
>>                                rinfo[j + 1].index = tmp;
>>                                rinfo[rinfo[j].index].rev_index = j;
>>                                rinfo[rinfo[j + 1].index].rev_index = j + 1;
>> -                               s = true;
>> +                               s = 1;
>>                        }
>>                if (!s)
>>                        break;

In fact, this entire hunk should be dropped.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
