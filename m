Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1EaQNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:13:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55310 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1EaQM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k9aplUrt9h3Y1g74Z9iFAykwJwd3TAkPecW+dXPSzC54KD8t90/nN2+SJZqa62F9Jw
         FwkjSSPrAH7iFIi+XGuI/JZFSd4ukGQPOhu6suvqg43s17kB1SKtwn126xuaoq8c59KO
         Da87H63C3oKSKPVLuLENs1DVi0zCLqIbZWbt4=
MIME-Version: 1.0
In-Reply-To: <1306856937.27477.3.camel@i7.infradead.org>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<1306795186.2029.459.camel@i7.infradead.org>
	<BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	<1306856937.27477.3.camel@i7.infradead.org>
Date: Tue, 31 May 2011 12:12:58 -0400
Message-ID: <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
Subject: Re: [PATCH] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 31, 2011 at 11:48 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2011-05-30 at 20:24 -0400, Arnaud Lacombe wrote:
>> It would seem that the underlying symbol is not visible, triggering
>> the failure of sym_set_tristate_value().
>
> Yes, this only lets you set *visible* symbols. If the symbol you're
> interested in is not visible because some of its dependencies are not
> set, it doesn't go and automatically enable those.
>
As for this choice, it *is* visible. You are missing a call to
`sym_calc_value()' (actually sym_calc_visibility() but it is not
exported) before the conditional to correct the visibility.

Beside that, if the environment is to influence the configuration
unconditionally, it would rather be better to do that when the Kconfig
are parsed.

 - Arnaud

> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>
