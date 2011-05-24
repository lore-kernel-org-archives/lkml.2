Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1EXPu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:50:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38324 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1EXPu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v5dtpuU2cxsYIIRasEkq5s3G9NKFhVD3/SUsXwpSM6g8KsntdX6HB68FwfdPHxol2L
         U4fQjmo9gB9Sk+xwbgFdN+29nSyszwSOtd3vWYHZ86Ct3uyKjBKzL94vSudf/Gce42J4
         BsuF03TvSPMGZR+g8JZ309MAKMTBZGYU0P310=
MIME-Version: 1.0
In-Reply-To: <4DDBC846.8050402@suse.cz>
References: <1306167401.18840.8.camel@hiromu-MacBook>
	<BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
	<1306242400.7501.10.camel@hiromu-MacBook>
	<4DDBB150.2090602@suse.cz>
	<1306247192.7501.25.camel@hiromu-MacBook>
	<4DDBC846.8050402@suse.cz>
Date: Tue, 24 May 2011 11:50:26 -0400
Message-ID: <BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Hiromu Yakura <hiromu1996@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 24, 2011 at 11:01 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 24.5.2011 16:26, Hiromu Yakura wrote:
>>
>> Hello,
>>
>> On Fri, May 24, 2011 at 22:23, Michal Marek<mmarek@suse.cz>  wrote:
>>>
>>> Arnaud's point is that your patch should not be necessary at all,
>>> because kconfig already checks the return value of the fopen() call in
>>> conf_write() and prints the above message if it fails. So do you have a
>>> testcase where make<...>config without your patch returns without
>>> error, but the configuration is not written?
>>
>> Sorry for misunderstanding.
>> Indeed, make *config which use 'conf' (e.g. oldconfig, defconfig...)
>> raise error.
>> And only xconfig and gconfig don't write the configuration without
>> error.
>
> I see, qconf lacks a check for the return value of conf_write() in
> ConfigMainWindow::closeEvent(), gconf does check the return value, but only
> displays it in the bottom box of the main window instead of a message box.
> Neither of them return failure in the error case. These bugs should be
> indeed fixed.
>
agree.

> But I don't like the directory permission check, it only
> handles one case, but does not handle permission on the .config file itself
> with KCONFIG_OVERWRITECONFIG=1, ENOSPC and so on.
>
seconded.

 - Arnaud
