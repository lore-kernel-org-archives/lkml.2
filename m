Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1GNM4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:56:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:33307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1GNM4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:56:10 -0400
Subject: Re: [PATCH] [RFCv3] perf: robustify proc and debugfs file recording
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Neuling <mikey@neuling.org>, Sonny Rao <sonnyrao@chromium.org>,
        acme@redhat.com, anton@samba.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310647558.27864.19.camel@gandalf.stny.rr.com>
References: <28585.1310602685@neuling.org>
	 <1310604019-10935-1-git-send-email-sonnyrao@chromium.org>
	 <1310612277.27864.5.camel@gandalf.stny.rr.com>
	 <10011.1310614483@neuling.org>
	 <1310647558.27864.19.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jul 2011 14:55:30 +0200
Message-ID: <1310648130.2586.251.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 08:45 -0400, Steven Rostedt wrote:
> ---
>  tools/perf/util/trace-event-info.c |  120 ++++++++------------------------=
> -----
>  1 file changed, 29 insertions(+), 91 deletions(-)
> 
> Index: linux-ozlabs/tools/perf/util/trace-event-info.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-ozlabs.orig/tools/perf/util/trace-event-info.c        2011-07-13 20:42:2=
> 4.442945973 +1000
> +++ linux-ozlabs/tools/perf/util/trace-event-info.c     2011-07-14 10:14:19.072=
> 946058 +1000
> @@ -183,106 +183,59 @@
>         return *ptr =3D=3D 0x01020304;
>  }
> =20
> -static unsigned long long copy_file_fd(int fd)
> +/* unfortunately, you can not stat debugfs or proc files for size */
> +static void record_file(const char *file, size_t hdr_sz)
>  {
>         unsigned long long size =3D 0;

Yeah, its all the rage, we're supposed to write full RFC compliant email
parsers these days :(

/Content-Transfer-Encoding:.*quoted-printable.*/ {
        decode = 1;
}

// {
	tmp = $0

	if (!decode) {
		print tmp
		next
	}

	if (concat) {
                tmp = last tmp
                concat = 0;
        }

        if (tmp ~ /=$/) {
                concat = 1;
                gsub("=$", "", tmp);
        }

        offset = 0;
        while (match(tmp, /=[[:xdigit:]][[:xdigit:]]/, a)) {
                if (a[0] < offset)
                        break;
                hex = substr(a[0], 2)
                char = sprintf("%c", strtonum("0x"hex))
                gsub(a[0], char, tmp)
                offset = a[0];
        }

        if (concat) {
                last = tmp
                next
        }

        print tmp
}


Should decode that crap I think..
