Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1JJOzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:55:52 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:33315 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1JJOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:55:51 -0400
Date: Mon, 10 Oct 2011 16:55:46 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCHv2 2/5] kgdb: follow rename pack_hex_byte to
	hex_byte_pack
Message-ID: <20111010145545.GL9412@axis.com>
References: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com> <34f5cdc31cb8bdd5596f0f20d5be2c867d9bcfa2.1318257114.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34f5cdc31cb8bdd5596f0f20d5be2c867d9bcfa2.1318257114.git.andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 04:33:36PM +0200, Andy Shevchenko wrote:
> There is no functional change.

For CRIS parts:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: kgdb-bugreport@lists.sourceforge.net
> ---
>  arch/cris/arch-v10/kernel/kgdb.c |    6 ++--
>  arch/cris/arch-v32/kernel/kgdb.c |   14 +++++-----
>  arch/frv/kernel/gdb-stub.c       |   44 ++++++++++++++++----------------
>  arch/mn10300/kernel/gdb-stub.c   |   52 +++++++++++++++++++-------------------
>  kernel/debug/gdbstub.c           |   12 ++++----
>  5 files changed, 64 insertions(+), 64 deletions(-)
> 
> diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
> index b9f9c8c..b579dd0 100644
> --- a/arch/cris/arch-v10/kernel/kgdb.c
> +++ b/arch/cris/arch-v10/kernel/kgdb.c
> @@ -694,7 +694,7 @@ mem2hex(char *buf, unsigned char *mem, int count)
>                  /* Valid mem address. */
>                  for (i = 0; i < count; i++) {
>                          ch = *mem++;
> -                       buf = pack_hex_byte(buf, ch);
> +                       buf = hex_byte_pack(buf, ch);
>                  }
>          }
> 
> @@ -868,7 +868,7 @@ stub_is_stopped(int sigval)
>         /* Send trap type (converted to signal) */
> 
>         *ptr++ = 'T';
> -       ptr = pack_hex_byte(ptr, sigval);
> +       ptr = hex_byte_pack(ptr, sigval);
> 
>         /* Send register contents. We probably only need to send the
>          * PC, frame pointer and stack pointer here. Other registers will be
> @@ -881,7 +881,7 @@ stub_is_stopped(int sigval)
>                  status = read_register (regno, &reg_cont);
> 
>                 if (status == SUCCESS) {
> -                       ptr = pack_hex_byte(ptr, regno);
> +                       ptr = hex_byte_pack(ptr, regno);
>                          *ptr++ = ':';
> 
>                          ptr = mem2hex(ptr, (unsigned char *)&reg_cont,
> diff --git a/arch/cris/arch-v32/kernel/kgdb.c b/arch/cris/arch-v32/kernel/kgdb.c
> index c0343c3..8c1d35c 100644
> --- a/arch/cris/arch-v32/kernel/kgdb.c
> +++ b/arch/cris/arch-v32/kernel/kgdb.c
> @@ -677,7 +677,7 @@ mem2hex(char *buf, unsigned char *mem, int count)
>                  /* Valid mem address. */
>                 for (i = 0; i < count; i++) {
>                         ch = *mem++;
> -                       buf = pack_hex_byte(buf, ch);
> +                       buf = hex_byte_pack(buf, ch);
>                 }
>          }
>          /* Terminate properly. */
> @@ -695,7 +695,7 @@ mem2hex_nbo(char *buf, unsigned char *mem, int count)
>         mem += count - 1;
>         for (i = 0; i < count; i++) {
>                 ch = *mem--;
> -               buf = pack_hex_byte(buf, ch);
> +               buf = hex_byte_pack(buf, ch);
>          }
> 
>          /* Terminate properly. */
> @@ -880,7 +880,7 @@ stub_is_stopped(int sigval)
>         /* Send trap type (converted to signal) */
> 
>         *ptr++ = 'T';
> -       ptr = pack_hex_byte(ptr, sigval);
> +       ptr = hex_byte_pack(ptr, sigval);
> 
>         if (((reg.exs & 0xff00) >> 8) == 0xc) {
> 
> @@ -988,26 +988,26 @@ stub_is_stopped(int sigval)
>         }
>         /* Only send PC, frame and stack pointer. */
>         read_register(PC, &reg_cont);
> -       ptr = pack_hex_byte(ptr, PC);
> +       ptr = hex_byte_pack(ptr, PC);
>         *ptr++ = ':';
>         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[PC]);
>         *ptr++ = ';';
> 
>         read_register(R8, &reg_cont);
> -       ptr = pack_hex_byte(ptr, R8);
> +       ptr = hex_byte_pack(ptr, R8);
>         *ptr++ = ':';
>         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[R8]);
>         *ptr++ = ';';
> 
>         read_register(SP, &reg_cont);
> -       ptr = pack_hex_byte(ptr, SP);
> +       ptr = hex_byte_pack(ptr, SP);
>         *ptr++ = ':';
>         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[SP]);
>         *ptr++ = ';';
> 
>         /* Send ERP as well; this will save us an entire register fetch in some cases. */
>          read_register(ERP, &reg_cont);
> -       ptr = pack_hex_byte(ptr, ERP);
> +       ptr = hex_byte_pack(ptr, ERP);
>          *ptr++ = ':';
>          ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[ERP]);
>          *ptr++ = ';';
> diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
> index a4dba6b..a6d5381 100644
> --- a/arch/frv/kernel/gdb-stub.c
> +++ b/arch/frv/kernel/gdb-stub.c
> @@ -672,7 +672,7 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
>         if ((uint32_t)mem&1 && count>=1) {
>                 if (!gdbstub_read_byte(mem,ch))
>                         return NULL;
> -               buf = pack_hex_byte(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[0]);
>                 mem++;
>                 count--;
>         }
> @@ -680,8 +680,8 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
>         if ((uint32_t)mem&3 && count>=2) {
>                 if (!gdbstub_read_word(mem,(uint16_t *)ch))
>                         return NULL;
> -               buf = pack_hex_byte(buf, ch[0]);
> -               buf = pack_hex_byte(buf, ch[1]);
> +               buf = hex_byte_pack(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[1]);
>                 mem += 2;
>                 count -= 2;
>         }
> @@ -689,10 +689,10 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
>         while (count>=4) {
>                 if (!gdbstub_read_dword(mem,(uint32_t *)ch))
>                         return NULL;
> -               buf = pack_hex_byte(buf, ch[0]);
> -               buf = pack_hex_byte(buf, ch[1]);
> -               buf = pack_hex_byte(buf, ch[2]);
> -               buf = pack_hex_byte(buf, ch[3]);
> +               buf = hex_byte_pack(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[1]);
> +               buf = hex_byte_pack(buf, ch[2]);
> +               buf = hex_byte_pack(buf, ch[3]);
>                 mem += 4;
>                 count -= 4;
>         }
> @@ -700,8 +700,8 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
>         if (count>=2) {
>                 if (!gdbstub_read_word(mem,(uint16_t *)ch))
>                         return NULL;
> -               buf = pack_hex_byte(buf, ch[0]);
> -               buf = pack_hex_byte(buf, ch[1]);
> +               buf = hex_byte_pack(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[1]);
>                 mem += 2;
>                 count -= 2;
>         }
> @@ -709,7 +709,7 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
>         if (count>=1) {
>                 if (!gdbstub_read_byte(mem,ch))
>                         return NULL;
> -               buf = pack_hex_byte(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[0]);
>         }
> 
>         *buf = 0;
> @@ -1498,21 +1498,21 @@ void gdbstub(int sigval)
>                 ptr = mem2hex(title, ptr, sizeof(title) - 1,0);
> 
>                 hx = hex_asc_hi(brr >> 24);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(brr >> 24);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(brr >> 16);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(brr >> 16);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(brr >> 8);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(brr >> 8);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(brr);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(brr);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
> 
>                 ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
>                 *ptr = 0;
> @@ -1526,10 +1526,10 @@ void gdbstub(int sigval)
> 
>         /* Send trap type (converted to signal) */
>         *ptr++ = 'T';
> -       ptr = pack_hex_byte(ptr, sigval);
> +       ptr = hex_byte_pack(ptr, sigval);
> 
>         /* Send Error PC */
> -       ptr = pack_hex_byte(ptr, GDB_REG_PC);
> +       ptr = hex_byte_pack(ptr, GDB_REG_PC);
>         *ptr++ = ':';
>         ptr = mem2hex(&__debug_frame->pc, ptr, 4, 0);
>         *ptr++ = ';';
> @@ -1537,7 +1537,7 @@ void gdbstub(int sigval)
>         /*
>          * Send frame pointer
>          */
> -       ptr = pack_hex_byte(ptr, GDB_REG_FP);
> +       ptr = hex_byte_pack(ptr, GDB_REG_FP);
>         *ptr++ = ':';
>         ptr = mem2hex(&__debug_frame->fp, ptr, 4, 0);
>         *ptr++ = ';';
> @@ -1545,7 +1545,7 @@ void gdbstub(int sigval)
>         /*
>          * Send stack pointer
>          */
> -       ptr = pack_hex_byte(ptr, GDB_REG_SP);
> +       ptr = hex_byte_pack(ptr, GDB_REG_SP);
>         *ptr++ = ':';
>         ptr = mem2hex(&__debug_frame->sp, ptr, 4, 0);
>         *ptr++ = ';';
> diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
> index 538266b..522eb8a 100644
> --- a/arch/mn10300/kernel/gdb-stub.c
> +++ b/arch/mn10300/kernel/gdb-stub.c
> @@ -798,7 +798,7 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
>         if ((u32) mem & 1 && count >= 1) {
>                 if (gdbstub_read_byte(mem, ch) != 0)
>                         return 0;
> -               buf = pack_hex_byte(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[0]);
>                 mem++;
>                 count--;
>         }
> @@ -806,8 +806,8 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
>         if ((u32) mem & 3 && count >= 2) {
>                 if (gdbstub_read_word(mem, ch) != 0)
>                         return 0;
> -               buf = pack_hex_byte(buf, ch[0]);
> -               buf = pack_hex_byte(buf, ch[1]);
> +               buf = hex_byte_pack(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[1]);
>                 mem += 2;
>                 count -= 2;
>         }
> @@ -815,10 +815,10 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
>         while (count >= 4) {
>                 if (gdbstub_read_dword(mem, ch) != 0)
>                         return 0;
> -               buf = pack_hex_byte(buf, ch[0]);
> -               buf = pack_hex_byte(buf, ch[1]);
> -               buf = pack_hex_byte(buf, ch[2]);
> -               buf = pack_hex_byte(buf, ch[3]);
> +               buf = hex_byte_pack(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[1]);
> +               buf = hex_byte_pack(buf, ch[2]);
> +               buf = hex_byte_pack(buf, ch[3]);
>                 mem += 4;
>                 count -= 4;
>         }
> @@ -826,8 +826,8 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
>         if (count >= 2) {
>                 if (gdbstub_read_word(mem, ch) != 0)
>                         return 0;
> -               buf = pack_hex_byte(buf, ch[0]);
> -               buf = pack_hex_byte(buf, ch[1]);
> +               buf = hex_byte_pack(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[1]);
>                 mem += 2;
>                 count -= 2;
>         }
> @@ -835,7 +835,7 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
>         if (count >= 1) {
>                 if (gdbstub_read_byte(mem, ch) != 0)
>                         return 0;
> -               buf = pack_hex_byte(buf, ch[0]);
> +               buf = hex_byte_pack(buf, ch[0]);
>         }
> 
>         *buf = 0;
> @@ -1273,13 +1273,13 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
>                 ptr = mem2hex(title, ptr, sizeof(title) - 1, 0);
> 
>                 hx = hex_asc_hi(excep >> 8);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(excep >> 8);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(excep);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(excep);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
> 
>                 ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
>                 *ptr = 0;
> @@ -1291,21 +1291,21 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
>                 ptr = mem2hex(tbcberr, ptr, sizeof(tbcberr) - 1, 0);
> 
>                 hx = hex_asc_hi(bcberr >> 24);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(bcberr >> 24);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(bcberr >> 16);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(bcberr >> 16);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(bcberr >> 8);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(bcberr >> 8);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_hi(bcberr);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
>                 hx = hex_asc_lo(bcberr);
> -               ptr = pack_hex_byte(ptr, hx);
> +               ptr = hex_byte_pack(ptr, hx);
> 
>                 ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
>                 *ptr = 0;
> @@ -1321,12 +1321,12 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
>          * Send trap type (converted to signal)
>          */
>         *ptr++ = 'T';
> -       ptr = pack_hex_byte(ptr, sigval);
> +       ptr = hex_byte_pack(ptr, sigval);
> 
>         /*
>          * Send Error PC
>          */
> -       ptr = pack_hex_byte(ptr, GDB_REGID_PC);
> +       ptr = hex_byte_pack(ptr, GDB_REGID_PC);
>         *ptr++ = ':';
>         ptr = mem2hex(&regs->pc, ptr, 4, 0);
>         *ptr++ = ';';
> @@ -1334,7 +1334,7 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
>         /*
>          * Send frame pointer
>          */
> -       ptr = pack_hex_byte(ptr, GDB_REGID_FP);
> +       ptr = hex_byte_pack(ptr, GDB_REGID_FP);
>         *ptr++ = ':';
>         ptr = mem2hex(&regs->a3, ptr, 4, 0);
>         *ptr++ = ';';
> @@ -1343,7 +1343,7 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
>          * Send stack pointer
>          */
>         ssp = (unsigned long) (regs + 1);
> -       ptr = pack_hex_byte(ptr, GDB_REGID_SP);
> +       ptr = hex_byte_pack(ptr, GDB_REGID_SP);
>         *ptr++ = ':';
>         ptr = mem2hex(&ssp, ptr, 4, 0);
>         *ptr++ = ';';
> diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
> index 3487248..c22d8c2 100644
> --- a/kernel/debug/gdbstub.c
> +++ b/kernel/debug/gdbstub.c
> @@ -217,7 +217,7 @@ void gdbstub_msg_write(const char *s, int len)
> 
>                 /* Pack in hex chars */
>                 for (i = 0; i < wcount; i++)
> -                       bufptr = pack_hex_byte(bufptr, s[i]);
> +                       bufptr = hex_byte_pack(bufptr, s[i]);
>                 *bufptr = '\0';
> 
>                 /* Move up */
> @@ -249,7 +249,7 @@ char *kgdb_mem2hex(char *mem, char *buf, int count)
>         if (err)
>                 return NULL;
>         while (count > 0) {
> -               buf = pack_hex_byte(buf, *tmp);
> +               buf = hex_byte_pack(buf, *tmp);
>                 tmp++;
>                 count--;
>         }
> @@ -411,14 +411,14 @@ static char *pack_threadid(char *pkt, unsigned char *id)
>         limit = id + (BUF_THREAD_ID_SIZE / 2);
>         while (id < limit) {
>                 if (!lzero || *id != 0) {
> -                       pkt = pack_hex_byte(pkt, *id);
> +                       pkt = hex_byte_pack(pkt, *id);
>                         lzero = 0;
>                 }
>                 id++;
>         }
> 
>         if (lzero)
> -               pkt = pack_hex_byte(pkt, 0);
> +               pkt = hex_byte_pack(pkt, 0);
> 
>         return pkt;
>  }
> @@ -486,7 +486,7 @@ static void gdb_cmd_status(struct kgdb_state *ks)
>         dbg_remove_all_break();
> 
>         remcom_out_buffer[0] = 'S';
> -       pack_hex_byte(&remcom_out_buffer[1], ks->signo);
> +       hex_byte_pack(&remcom_out_buffer[1], ks->signo);
>  }
> 
>  static void gdb_get_regs_helper(struct kgdb_state *ks)
> @@ -954,7 +954,7 @@ int gdb_serial_stub(struct kgdb_state *ks)
>                 /* Reply to host that an exception has occurred */
>                 ptr = remcom_out_buffer;
>                 *ptr++ = 'T';
> -               ptr = pack_hex_byte(ptr, ks->signo);
> +               ptr = hex_byte_pack(ptr, ks->signo);
>                 ptr += strlen(strcpy(ptr, "thread:"));
>                 int_to_threadref(thref, shadow_pid(current->pid));
>                 ptr = pack_threadid(ptr, thref);
> --
> 1.7.6.3
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
