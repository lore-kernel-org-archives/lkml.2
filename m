Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab1LFPFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:05:49 -0500
Received: from ffm.saftware.de ([83.141.3.46]:34167 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409Ab1LFPFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:05:48 -0500
Message-ID: <4EDE2F49.3030108@linuxtv.org>
Date: Tue, 06 Dec 2011 16:05:45 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4EDE1733.8060409@redhat.com> <4EDE1D57.90307@linuxtv.org> <201112061619.31357.remi@remlab.net>
In-Reply-To: <201112061619.31357.remi@remlab.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2011 15:19, Rémi Denis-Courmont wrote:
> Le mardi 6 décembre 2011 15:49:11 Andreas Oberritter, vous avez écrit :
>> You don't need to wait for write-only operations. Basically all demux
>> ioctls are write-only. Since vtunerc is using dvb-core's software demux
>> *locally*, errors for invalid arguments etc. will be returned as usual.
> 
> That's a limitation, not a feature.

You misunderstood.

> You should not transmit unwanted programs over the network, nor copy them to 
> kernel space.

I agree. And nobody said that this would happen. The software demux
receives pre-filtered data. Still the ioctls are local. Just a trigger
to start or stop filters needs to be sent to the remote demux, just like
a register setting would be needed for a local hardware demux.
