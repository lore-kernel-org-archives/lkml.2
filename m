Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1J0Bv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 21:51:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51292 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1J0Bv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 21:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <20111026210641.GA28437@kroah.com>
References: <20111026120725.GA23142@kroah.com> <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
 <20111026210641.GA28437@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Oct 2011 03:51:06 +0200
X-Google-Sender-Auth: uwpj3Q5mQcbqXATui4tN80eRCAQ
Message-ID: <CA+55aFzM+crPgD_763HR=KrJMudTTCbiYSbqSrPY2TR-Go9W5A@mail.gmail.com>
Subject: Re: [GIT PATCH] big staging merge for 3.2
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, Mark Einon <mark.einon@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:06 PM, Greg KH <greg@kroah.com> wrote:
>>
>> Hmm... I only get
>>
>>  725 files changed, 103936 insertions(+), 180480 deletions(-)
>>
>> Which is still good, but nothing like your numbers. Where did you find
>> the extra 50k lines?
>
> I don't know, I took it straight from git.
>
> I did a:
>        git diff -M --stat --summary master..HEAD
>
> And in that tree master was v3.1 and HEAD was 43a3beb6da994549ec28a9f31727b997a025f958
> so if you do:
>        git diff -M --stat --summary v3.1..43a3beb6da994549ec28a9f31727b997a025f958
>
> in your tree, I also get the above diffstat:
>
> $ git diff -M --stat --summary v3.1..43a3beb6da994549ec28a9f31727b997a025f958 | grep insert
>  834 files changed, 103718 insertions(+), 230262 deletions(-)
>
> Did I do that wrong?  There are a lot of renames, is my default value
> for git different than what you might have on your box?  Or am I diffing
> the wrong thing here?

No, what apparently happened is that some of the removals had already
come in through the networking tree (ath6kl in particular). So I had
merged that earlier - and git merged it all fine - and thus to me the
staging tree didn't remove as much as it did for you ;)

See commit 9ac4025d8088 (yours) and af2bf4b4ee58 (network tree)..

And yeah, that driver was about 50k lines.

           Linus
