Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0LVQhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:37:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63859 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0LVQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=FAbmSTeOCRBdLboIs1BLv3SA94Rbl8gXwCNfDOD4yUxwPC3cpwv9uvMXhHHLkkxKYg
         UHnfY2czy9Vgh5iROtEd98MOBQL4s4zdBjSmwTbGVEWhVvH92napZVWrba+I6GUres2A
         sxT+QC4rRbc91Ji3NZ1NfyxcSXcR+HiFTbHfk=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Subject: Re: [tip:perf/core] perf probe: Don't always consider EOF as an error when listing source code
References: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
	<tip-fde52dbd7f71934aba4e150f3d1d51e826a08850@git.kernel.org>
	<m34oa6t0e4.fsf@gmail.com> <20101222144338.GA17134@ghostprotocols.net>
Date: Wed, 22 Dec 2010 17:37:13 +0100
In-Reply-To: <20101222144338.GA17134@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 22 Dec 2010 12:43:38 -0200")
Message-ID: <m3y67hsr0m.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@infradead.org> writes:

> Em Wed, Dec 22, 2010 at 02:14:43PM +0100, Franck Bui-Huu escreveu:
>> tip-bot for Franck Bui-Huu <fbuihuu@gmail.com> writes:
>> >  error:
>> > -	if (feof(fp))
>
>> > +	if (ferror(fp)) {
>> >  		pr_warning("Source file is shorter than expected.\n");
>> > -	else
>> > -		pr_warning("File read error: %s\n", strerror(errno));
>> > +		return -1;
>> 
>> Argh, something wrong here.
>> 
>> The warning left here, is the wrong one, I should have left the other
>> one.
>> 
>> Sorry for the mistake.
>> 
>> Should I send a patch to fix that ?
>
> Please.
>

[PATCH] perf-probe: Fix wrong warning in __show_one_line() if read(1) errors happen

From: Franck Bui-Huu <fbuihuu@gmail.com>

This was introduced by commit fde52dbd7f71934aba4e150f3d1d51e826a08850.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 469ad35..10ad1ad 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -319,7 +319,7 @@ static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 	return 1;
 error:
 	if (ferror(fp)) {
-		pr_warning("Source file is shorter than expected.\n");
+		pr_warning("File read error: %s\n", strerror(errno));
 		return -1;
 	}
 	return 0;
-- 
1.7.3.2



-- 
		Franck
