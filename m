Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0KLIMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:12:31 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:43978 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0KLIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:12:29 -0500
Message-ID: <4CDCF500.8000708@web.de>
Date: Fri, 12 Nov 2010 09:04:16 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] trace-view: Handle unknown events more gracefully
References: <4CB758C1.8090906@web.de>
In-Reply-To: <4CB758C1.8090906@web.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD320F51C7A856B7B7C16F5C8"
X-Provags-ID: V01U2FsdGVkX1/2cqfLFY3J3gTqFHzCfsxhETYZ44BIDTYl4v1h
	RpFHH2ug7MIjQqU/L2KPpt0XkOurl8oRBPtW5A8b7hRUbAK98u
	TBp+gbVY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD320F51C7A856B7B7C16F5C8
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.10.2010 21:23, Jan Kiszka wrote:
> Kernel 2.6.35.7 generates invalid trace files due to
> /sys/kernel/debug/tracing/events/scsi/scsi_dispatch_cmd_timeout/format
> returning "FORMAT TOO BIG" (seems to be fixed in 2.6.36). This makes
> pevent_data_event_from_type return NULL, and dereferencing of event
> crashes the viewer.
>=20
> Catch and report the error properly.

Ping...

Jan

>=20
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> ---
>  trace-view-store.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>=20
> diff --git a/trace-view-store.c b/trace-view-store.c
> index 0834df7..34f8155 100644
> --- a/trace-view-store.c
> +++ b/trace-view-store.c
> @@ -507,12 +507,17 @@ trace_view_store_get_value (GtkTreeModel *tree_mo=
del,
>  		case TRACE_VIEW_STORE_COL_INFO:
>  			val =3D pevent_data_type(pevent, data);
>  			event =3D pevent_data_event_from_type(pevent, val);
> +			if (!event) {
> +				if (column =3D=3D TRACE_VIEW_STORE_COL_EVENT)
> +					g_value_set_string(value, "[UNKNOWN EVENT]");
> +				break;
> +			}
> +
>  			if (column =3D=3D TRACE_VIEW_STORE_COL_EVENT) {
>  				g_value_set_string(value, event->name);
>  				break;
>  			}
> =20
> -		=09
>  			trace_seq_init(&s);
>  			pevent_event_info(&s, event, data);
>  			g_value_set_string(value, s.buffer);



--------------enigD320F51C7A856B7B7C16F5C8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzc9QMACgkQitSsb3rl5xS8hgCeObNHXZs/XnNXjrKq8FqbbI/z
zvAAoO+QutB/FJoec0yXbpMm+w1nVDO5
=71gO
-----END PGP SIGNATURE-----

--------------enigD320F51C7A856B7B7C16F5C8--
