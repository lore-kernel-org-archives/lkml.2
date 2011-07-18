Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1GRTC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:02:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55489 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1GRTC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MVhYKgLzOUqqFPS1h4hUEG9_q0N_QeifHFWjxHyianVkA@mail.gmail.com>
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
	<1310282825-14509-1-git-send-email-lacombar@gmail.com>
	<CACqU3MVhYKgLzOUqqFPS1h4hUEG9_q0N_QeifHFWjxHyianVkA@mail.gmail.com>
Date: Mon, 18 Jul 2011 15:02:55 -0400
Message-ID: <CACqU3MXEepOX=Mxvi+fFFrziNYkHGwPba5c=+ZTWtGXzrC_RrA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kconfig/nconf: use the generic menu_get_ext_help()
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Andrej Gelenberg <andrej.gelenberg@udo.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 18, 2011 at 2:11 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 10, 2011 at 3:27 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> nconf is the only front-end which does not use this helper, but prefer to
>> copy/paste the code. The test wrt. menu validity added in this version of the
>> code is bogus anyway as an invalid menu will get dereferenced a few line below
>> by calling menu_get_prompt().
>>
>> For now, convert nconf to use menu_get_ext_help(), as do every other front-end.
>> We will deals with menu validity checks properly in a separate commit.
>>
>> Cc: Nir Tzachar <nir.tzachar@gmail.com>
>> Cc: Andrej Gelenberg <andrej.gelenberg@udo.edu>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  scripts/kconfig/nconf.c |   14 +-------------
>>  1 files changed, 1 insertions(+), 13 deletions(-)
>>
>> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
>> index da9f5c4..24fc79a 100644
>> --- a/scripts/kconfig/nconf.c
>> +++ b/scripts/kconfig/nconf.c
>> @@ -1223,19 +1223,7 @@ static void conf_message_callback(const char *fmt, va_list ap)
>>  static void show_help(struct menu *menu)
>>  {
>>        struct gstr help = str_new();
>> -
>> -       if (menu && menu->sym && menu_has_help(menu)) {
>> -               if (menu->sym->name) {
>> -                       str_printf(&help, "%s%s:\n\n", CONFIG_, menu->sym->name);
>> -                       str_append(&help, _(menu_get_help(menu)));
>> -                       str_append(&help, "\n");
>> -                       get_symbol_str(&help, menu->sym);
>> -               } else {
>> -                       str_append(&help, _(menu_get_help(menu)));
>> -               }
>> -       } else {
>> -               str_append(&help, nohelp_text);
>> -       }
>> +       menu_get_ext_help(menu, &help);
>>        show_scroll_win(main_window, _(menu_get_prompt(menu)), str_get(&help));
>>        str_free(&help);
>>  }
>>
> Michal, ping ?
>
Sorry for my last 3 ping, the patches in question have been merged, I
did not pay attention :-).

 - Arnaud
