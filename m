Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1C3LPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:15:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61768 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1C3LO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c+qq8Z3WhmZfgNlwa1hXfnpDzI1SQcYQS8MQ2mPlF7E2TnUmW1Dr6chOmpiP+CEtZq
         vWB10SDp9zVs1o4o/5K53nTInThl66hwIK1cyVWmZ5OvufCf+4QAX+czJ+gPTeLegT9F
         1+/dklYKcLPwdwPqKXdQT/rsXE1uDnlLNvBL0=
Date: Wed, 30 Mar 2011 14:21:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330112126.GA3967@swordfish.minsk.epam.com>
References: <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <4D9302ED.4030807@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <4D9302ED.4030807@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (03/30/11 12:16), Jens Axboe wrote:
> How does this look? It's really two patches, but rolled up into one for
> easier posting here.
>=20

Nope, doesn't work for me. fsck.ext4 crashed the system.

__elv_add_request
blk_flush_complete_seq
blk_insert_flush
__elv_add_request
__make_request
generic_make_request
?bio_alloc_bioset
blkdev_issue_flush
blkdev_fsync
vfs_fsync
[..]

RIP is on blk_insert_flush + 0x54, which is one of the BUG_ONs

Dump of assembler code for function blk_insert_flush:
   0x00000000000004a4 <+0>:	push   %rbp
   0x00000000000004a5 <+1>:	xor    %esi,%esi
   0x00000000000004a7 <+3>:	mov    %rdi,%r8
   0x00000000000004aa <+6>:	mov    0x38(%rdi),%rax
   0x00000000000004ae <+10>:	mov    %rsp,%rbp
   0x00000000000004b1 <+13>:	mov    0x6d4(%rax),%edx
   0x00000000000004b7 <+19>:	test   $0x800000,%edx
   0x00000000000004bd <+25>:	je     0x4ee <blk_insert_flush+74>
   0x00000000000004bf <+27>:	mov    0x40(%rdi),%ecx
   0x00000000000004c2 <+30>:	xor    %esi,%esi
   0x00000000000004c4 <+32>:	mov    0x54(%rdi),%r9d
   0x00000000000004c8 <+36>:	test   $0x800000,%ecx
   0x00000000000004ce <+42>:	setne  %sil
   0x00000000000004d2 <+46>:	mov    %esi,%edi
   0x00000000000004d4 <+48>:	or     $0x2,%edi
   0x00000000000004d7 <+51>:	shr    $0x9,%r9d
   0x00000000000004db <+55>:	cmovne %edi,%esi
   0x00000000000004de <+58>:	test   $0x10,%dh
   0x00000000000004e1 <+61>:	jne    0x4ee <blk_insert_flush+74>
   0x00000000000004e3 <+63>:	mov    %esi,%edi
   0x00000000000004e5 <+65>:	or     $0x4,%edi
   0x00000000000004e8 <+68>:	and    $0x10,%ch
   0x00000000000004eb <+71>:	cmovne %edi,%esi
   0x00000000000004ee <+74>:	cmpq   $0x0,0x148(%r8)
   0x00000000000004f6 <+82>:	je     0x4fa <blk_insert_flush+86>
   0x00000000000004f8 <+84>:	ud2a  =20
			^^^^^^^^^^^^
   0x00000000000004fa <+86>:	mov    0x60(%r8),%rcx
   0x00000000000004fe <+90>:	test   %rcx,%rcx
   0x0000000000000501 <+93>:	je     0x509 <blk_insert_flush+101>
   0x0000000000000503 <+95>:	cmp    0x68(%r8),%rcx
   0x0000000000000507 <+99>:	je     0x50b <blk_insert_flush+103>
   0x0000000000000509 <+101>:	ud2a  =20



	Sergey



> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 93d5fd8..6a16fea 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -261,7 +261,7 @@ static bool blk_kick_flush(struct request_queue *q)
>  	q->flush_rq.end_io =3D flush_end_io;
> =20
>  	q->flush_pending_idx ^=3D 1;
> -	elv_insert(q, &q->flush_rq, ELEVATOR_INSERT_REQUEUE);
> +	__elv_add_request(q, &q->flush_rq, ELEVATOR_INSERT_FLUSH);
>  	return true;
>  }
> =20
> @@ -281,7 +281,7 @@ static void flush_data_end_io(struct request *rq, int=
 error)
>   * blk_insert_flush - insert a new FLUSH/FUA request
>   * @rq: request to insert
>   *
> - * To be called from elv_insert() for %ELEVATOR_INSERT_FLUSH insertions.
> + * To be called from __elv_add_request() for %ELEVATOR_INSERT_FLUSH inse=
rtions.
>   * @rq is being submitted.  Analyze what needs to be done and put it on =
the
>   * right queue.
>   *
> @@ -312,7 +312,7 @@ void blk_insert_flush(struct request *rq)
>  	 */
>  	if ((policy & REQ_FSEQ_DATA) &&
>  	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
> -		list_add(&rq->queuelist, &q->queue_head);
> +		list_add_tail(&rq->queuelist, &q->queue_head);
>  		return;
>  	}
> =20
> diff --git a/block/elevator.c b/block/elevator.c
> index c387d31..0cdb4e7 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -610,7 +610,7 @@ void elv_requeue_request(struct request_queue *q, str=
uct request *rq)
> =20
>  	rq->cmd_flags &=3D ~REQ_STARTED;
> =20
> -	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
> +	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
>  }
> =20
>  void elv_drain_elevator(struct request_queue *q)
> @@ -655,12 +655,25 @@ void elv_quiesce_end(struct request_queue *q)
>  	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
>  }
> =20
> -void elv_insert(struct request_queue *q, struct request *rq, int where)
> +void __elv_add_request(struct request_queue *q, struct request *rq, int =
where)
>  {
>  	trace_block_rq_insert(q, rq);
> =20
>  	rq->q =3D q;
> =20
> +	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
> +
> +	if (rq->cmd_flags & REQ_SOFTBARRIER) {
> +		/* barriers are scheduling boundary, update end_sector */
> +		if (rq->cmd_type =3D=3D REQ_TYPE_FS ||
> +		    (rq->cmd_flags & REQ_DISCARD)) {
> +			q->end_sector =3D rq_end_sector(rq);
> +			q->boundary_rq =3D rq;
> +		}
> +	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
> +		    where =3D=3D ELEVATOR_INSERT_SORT)
> +		where =3D ELEVATOR_INSERT_BACK;
> +
>  	switch (where) {
>  	case ELEVATOR_INSERT_REQUEUE:
>  	case ELEVATOR_INSERT_FRONT:
> @@ -722,24 +735,6 @@ void elv_insert(struct request_queue *q, struct requ=
est *rq, int where)
>  		BUG();
>  	}
>  }
> -
> -void __elv_add_request(struct request_queue *q, struct request *rq, int =
where)
> -{
> -	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
> -
> -	if (rq->cmd_flags & REQ_SOFTBARRIER) {
> -		/* barriers are scheduling boundary, update end_sector */
> -		if (rq->cmd_type =3D=3D REQ_TYPE_FS ||
> -		    (rq->cmd_flags & REQ_DISCARD)) {
> -			q->end_sector =3D rq_end_sector(rq);
> -			q->boundary_rq =3D rq;
> -		}
> -	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
> -		    where =3D=3D ELEVATOR_INSERT_SORT)
> -		where =3D ELEVATOR_INSERT_BACK;
> -
> -	elv_insert(q, rq, where);
> -}
>  EXPORT_SYMBOL(__elv_add_request);
> =20
>  void elv_add_request(struct request_queue *q, struct request *rq, int wh=
ere)
> diff --git a/include/linux/elevator.h b/include/linux/elevator.h
> index d93efcc445..21a8ebf 100644
> --- a/include/linux/elevator.h
> +++ b/include/linux/elevator.h
> @@ -101,7 +101,6 @@ extern void elv_dispatch_sort(struct request_queue *,=
 struct request *);
>  extern void elv_dispatch_add_tail(struct request_queue *, struct request=
 *);
>  extern void elv_add_request(struct request_queue *, struct request *, in=
t);
>  extern void __elv_add_request(struct request_queue *, struct request *, =
int);
> -extern void elv_insert(struct request_queue *, struct request *, int);
>  extern int elv_merge(struct request_queue *, struct request **, struct b=
io *);
>  extern int elv_try_merge(struct request *, struct bio *);
>  extern void elv_merge_requests(struct request_queue *, struct request *,
>=20
> --=20
> Jens Axboe
>=20

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2TEjYACgkQfKHnntdSXjQ6EwQAtFq0GIjsnS03msZ/9+XobyMB
OokVEzkLEZpb+A+K14GaMiwLeJ8ojJRopLUVQ6d3IsaUW19heViE5PnWIRQ3y0vp
aBR/GA3GCtPv07Iqp2Af619v+1Ucx7pRwiD9je1ZfeSCCPA3MfPjKs8coa6gLnFv
p1IYSFXrwPieBmaaquU=
=0/N4
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
