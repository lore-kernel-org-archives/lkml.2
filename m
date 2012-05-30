Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2E3Bnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:43:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36374 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab2E3Bn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:43:28 -0400
Message-ID: <1338342203.2658.544.camel@shawn-ssd>
Subject: Re: include/linux/dynamic_debug.h:111:2: error: implicit
 declaration of function =?UTF-8?Q?=E2=80=98strstr=E2=80=99?=
From: shawn <shawnlandden@gmail.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2012 18:43:23 -0700
In-Reply-To: <CAJfuBxweY7sG2KZDPHsrOP6iu8sQxw8EvCKA1QtGnDFKA92zag@mail.gmail.com>
References: <1338334286.2658.536.camel@shawn-ssd>
	 <CAJfuBxweY7sG2KZDPHsrOP6iu8sQxw8EvCKA1QtGnDFKA92zag@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-H4eAEtgm1rSVBHZbd+VJ"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H4eAEtgm1rSVBHZbd+VJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

jim,
On Tue, 2012-05-29 at 19:11 -0600, Jim Cromie wrote: 
> On Tue, May 29, 2012 at 5:31 PM, shawn <shawnlandden@gmail.com> wrote:
> >  SHIPPED arch/arm/boot/compressed/lib1funcs.S
> > In file included from include/linux/kernel.h:23:0,
> >                 from
> > arch/arm/boot/compressed/../../../../lib/xz/xz_private.h:15,
> >                 from
> > arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:145,
> >                 from arch/arm/boot/compressed/decompress.c:50:
> > include/linux/dynamic_debug.h: In function
> > ‘ddebug_dyndbg_module_param_cb’:
> > include/linux/dynamic_debug.h:111:2: error: implicit declaration of
> > function ‘strstr’ [-Werror=implicit-function-declaration]
> >
> > git blame shows b48420c1d3019ce8d84fb8e58f4ca86b8e3655b8 as introducing
> > this call
> 
> that symbol should have been provided by line 100
> 
>      98 #else
>      99
>     100 #include <linux/string.h>
>     101 #include <linux/errno.h>
> ...
>     108 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
>     109                                                 const char *modname)
>     110 {
>     111         if (strstr(param, "dyndbg")) {

> which has:
> 
>      74 #ifndef __HAVE_ARCH_STRSTR
>      75 extern char * strstr(const char *, const char *);
>      76 #endif
> does your arch have __HAVE_ARCH_STRSTR ?
> if so, is strstr exported under different conditions ??
a git grep __HAVE_ARCH_STRSTR did not show and such defines in the arm
tree 
> 
> Can you send me
> arch/arm/boot/compressed/decompress.i  ?
I didn't have that file after the failure, but 

make arch/arm/boot/compressed/decompress.i

summoned it, also including string.o from that folder (which was present
after the failure)

I am compiling on amd64, using 
export ARCH=arm
and 
CONFIG_CROSS_COMPILE="arm-linux-gnueabi-"


I have had issues with the cross compiler not always being called since
the 3.5 merge window opened up, (ld reporting corrupted binary files and
gcc saying it doesn't understand arm-specific flags) and have not yet
compiled a post-v3.4 successful kernel. This could be a symptom of that.
(esp as the host arch, x86 DOES have __HAVE_ARCH_STRSTR)

-- 
-Shawn Landden

--=-H4eAEtgm1rSVBHZbd+VJ
Content-Type: application/x-object; name="string.o"
Content-Disposition: attachment; filename="string.o"
Content-Transfer-Encoding: base64

f0VMRgEBAQAAAAAAAAAAAAEAKAABAAAAAAAAAAAAAABkAwAAAAAABTQAAAAAACgADgALAHBALemi
QaDhAcCg4QAwoOEEUKDhEgAA6gBg3OUBUEXiAGDD5QFg3OUBYMPlAmDc5QJgw+UDYNzlA2DD5QRg
3OUEYMPlBWDc5QVgw+UGYNzlBmDD5Qdg3OUIwIziB2DD5Qgwg+IAAFXj6v//ysRPxOGEwaDhBAAS
4wwwgOAMwIHgCQAACoQR0eeEEcDnARDc5QEQw+UCENzlAhDD5QMQ3OUEwIziAxDD5QQwg+ICABLj
BQAACgAQ3OUAEMPlARDc5QLAjOIBEMPlAjCD4gEAEuMAINwVACDDFXCAvegBAFDhEEAt6QDAoOEB
QKDhAjCg4QcAAAoEAAAqEEC96P7//+oBMEPiAyDU5wMgzOcAAFPj+v//GgwAoOEQgL3oADCg4QMg
oOEAENLlATCD4gAAUeP6//8aAgBg4B7/L+ECIIDgADCg4QQAAOoAwNDlAQDR5AEwg+IAAFzgHv8v
EQIAU+EDAKDh9///OgAAoOMe/y/hADCg4QEg0+QBANHkAABS4B7/LxEAAFLj+f//Gh7/L+H/EAHi
BQAA6gDA0OUBMIDiASBC4gEAXOEe/y8BAwCg4QAAUuP3//8aAgCg4R7/L+H/EAHiAQAA6gAAUuMF
AAAKACDQ5QAwoOEBAIDiAQBS4fj//xoAAADqAjCg4QMAoOEe/y/hADCg4wEAAOoDEMDnATCD4gIA
U+H7//8aHv8v4QEgoOEAEKDj/v//6gAAAACwsKqA3AAAALCwqIAcAQAAsLCwgDwBAACwsLCAcAEA
ALCwsICQAQAAsLCwgMABAACwsLCA9AEAALCwsIAQAgAAsLCwgABHQ0M6IChVYnVudHUvTGluYXJv
IDQuNi4zLTF1YnVudHU1KSA0LjYuMwBBLAAAAGFlYWJpAAEiAAAABTVURQAGBAgBCQESBBQBFQEX
AxgBGQEaAh4ELAEALnN5bXRhYgAuc3RydGFiAC5zaHN0cnRhYgAucmVsLnRleHQALmRhdGEALmJz
cwAuQVJNLmV4dGFiAC5yZWwuQVJNLmV4aWR4AC5jb21tZW50AC5ub3RlLkdOVS1zdGFjawAuQVJN
LmF0dHJpYnV0ZXMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfAAAA
AQAAAAYAAAAAAAAANAAAABwCAAAAAAAAAAAAAAQAAAAAAAAAGwAAAAkAAAAAAAAAAAAAAGAHAAAQ
AAAADAAAAAEAAAAEAAAACAAAACUAAAABAAAAAwAAAAAAAABQAgAAAAAAAAAAAAAAAAAAAQAAAAAA
AAArAAAACAAAAAMAAAAAAAAAUAIAAAAAAAAAAAAAAAAAAAEAAAAAAAAAMAAAAAEAAAACAAAAAAAA
AFACAAAAAAAAAAAAAAAAAAABAAAAAAAAAD8AAAABAABwggAAAAAAAABQAgAASAAAAAEAAAAAAAAA
BAAAAAAAAAA7AAAACQAAAAAAAAAAAAAAcAcAAFAAAAAMAAAABgAAAAQAAAAIAAAASgAAAAEAAAAw
AAAAAAAAAJgCAAArAAAAAAAAAAAAAAABAAAAAQAAAFMAAAABAAAAAAAAAAAAAADDAgAAAAAAAAAA
AAAAAAAAAQAAAAAAAABjAAAAAwAAcAAAAAAAAAAAwwIAAC0AAAAAAAAAAAAAAAEAAAAAAAAAEQAA
AAMAAAAAAAAAAAAAAPACAABzAAAAAAAAAAAAAAABAAAAAAAAAAEAAAACAAAAAAAAAAAAAACUBQAA
YAEAAA0AAAAMAAAABAAAABAAAAAJAAAAAwAAAAAAAAAAAAAA9AYAAGoAAAAAAAAAAAAAAAEAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAQA8f8AAAAAAAAAAAAAAAADAAEAAAAAAAAA
AAAAAAAAAwADAAAAAAAAAAAAAAAAAAMABAAKAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAwAF
AAAAAAAAAAAAAAAAAAMABgANAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAwAJAAAAAAAAAAAA
AAAAAAMACAAAAAAAAAAAAAAAAAADAAoAEAAAAAAAAADcAAAAEgABABcAAAAAAAAAAAAAABAAAAAu
AAAA3AAAAEAAAAASAAEANgAAABwBAAAgAAAAEgABAD0AAAA8AQAANAAAABIAAQBEAAAAcAEAACAA
AAASAAEASwAAAJABAAAwAAAAEgABAFIAAADAAQAANAAAABIAAQBZAAAA9AEAABwAAAASAAEAYAAA
ABACAAAMAAAAEgABAABzdHJpbmcuYwAkYQAkZABtZW1jcHkAX19hZWFiaV91bndpbmRfY3BwX3By
MABtZW1tb3ZlAHN0cmxlbgBtZW1jbXAAc3RyY21wAG1lbWNocgBzdHJjaHIAbWVtc2V0AF9fbWVt
emVybwAAAPwAAAAbDAAAGAIAABsUAAAAAAAAKgIAAAAAAAAADQAACAAAACoCAAAQAAAAKgIAABgA
AAAqAgAAIAAAACoCAAAoAAAAKgIAADAAAAAqAgAAOAAAACoCAABAAAAAKgIAAA==


--=-H4eAEtgm1rSVBHZbd+VJ
Content-Disposition: attachment; filename="decompress.i"
Content-Type: text/plain; name="decompress.i"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

# 1 "arch/arm/boot/compressed/decompress.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/home/shawn/source/linux/include/linux/kconfig.h" 1



# 1 "include/generated/autoconf.h" 1
# 5 "/home/shawn/source/linux/include/linux/kconfig.h" 2
# 1 "<command-line>" 2
# 1 "arch/arm/boot/compressed/decompress.c"


# 1 "include/linux/compiler.h" 1
# 48 "include/linux/compiler.h"
# 1 "include/linux/compiler-gcc.h" 1
# 100 "include/linux/compiler-gcc.h"
# 1 "include/linux/compiler-gcc4.h" 1
# 101 "include/linux/compiler-gcc.h" 2
# 49 "include/linux/compiler.h" 2
# 66 "include/linux/compiler.h"
struct ftrace_branch_data {
 const char *func;
 const char *file;
 unsigned line;
 union {
  struct {
   unsigned long correct;
   unsigned long incorrect;
  };
  struct {
   unsigned long miss;
   unsigned long hit;
  };
  unsigned long miss_hit[2];
 };
};
# 4 "arch/arm/boot/compressed/decompress.c" 2
# 1 "include/linux/types.h" 1



# 1 "/home/shawn/source/linux/arch/arm/include/asm/types.h" 1



# 1 "include/asm-generic/int-ll64.h" 1
# 11 "include/asm-generic/int-ll64.h"
# 1 "arch/arm/include/generated/asm/bitsperlong.h" 1
# 1 "include/asm-generic/bitsperlong.h" 1
# 1 "arch/arm/include/generated/asm/bitsperlong.h" 2
# 12 "include/asm-generic/int-ll64.h" 2







typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short __u16;

typedef __signed__ int __s32;
typedef unsigned int __u32;


__extension__ typedef __signed__ long long __s64;
__extension__ typedef unsigned long long __u64;
# 42 "include/asm-generic/int-ll64.h"
typedef signed char s8;
typedef unsigned char u8;

typedef signed short s16;
typedef unsigned short u16;

typedef signed int s32;
typedef unsigned int u32;

typedef signed long long s64;
typedef unsigned long long u64;
# 5 "/home/shawn/source/linux/arch/arm/include/asm/types.h" 2
# 5 "include/linux/types.h" 2
# 17 "include/linux/types.h"
# 1 "include/linux/posix_types.h" 1



# 1 "include/linux/stddef.h" 1
# 11 "include/linux/stddef.h"
enum {
 false =3D 0,
 true =3D 1
};
# 5 "include/linux/posix_types.h" 2
# 36 "include/linux/posix_types.h"
typedef struct {
 unsigned long fds_bits [(1024/(8 * sizeof(unsigned long)))];
} __kernel_fd_set;


typedef void (*__kernel_sighandler_t)(int);


typedef int __kernel_key_t;
typedef int __kernel_mqd_t;

# 1 "/home/shawn/source/linux/arch/arm/include/asm/posix_types.h" 1
# 22 "/home/shawn/source/linux/arch/arm/include/asm/posix_types.h"
typedef unsigned short __kernel_mode_t;


typedef unsigned short __kernel_nlink_t;


typedef unsigned short __kernel_ipc_pid_t;


typedef unsigned short __kernel_uid_t;
typedef unsigned short __kernel_gid_t;


typedef unsigned short __kernel_old_dev_t;


# 1 "include/asm-generic/posix_types.h" 1



# 1 "arch/arm/include/generated/asm/bitsperlong.h" 1
# 5 "include/asm-generic/posix_types.h" 2
# 14 "include/asm-generic/posix_types.h"
typedef long __kernel_long_t;
typedef unsigned long __kernel_ulong_t;



typedef __kernel_ulong_t __kernel_ino_t;
# 31 "include/asm-generic/posix_types.h"
typedef int __kernel_pid_t;
# 44 "include/asm-generic/posix_types.h"
typedef __kernel_long_t __kernel_suseconds_t;



typedef int __kernel_daddr_t;



typedef unsigned int __kernel_uid32_t;
typedef unsigned int __kernel_gid32_t;



typedef __kernel_uid_t __kernel_old_uid_t;
typedef __kernel_gid_t __kernel_old_gid_t;
# 71 "include/asm-generic/posix_types.h"
typedef unsigned int __kernel_size_t;
typedef int __kernel_ssize_t;
typedef int __kernel_ptrdiff_t;
# 82 "include/asm-generic/posix_types.h"
typedef struct {
 int val[2];
} __kernel_fsid_t;





typedef __kernel_long_t __kernel_off_t;
typedef long long __kernel_loff_t;
typedef __kernel_long_t __kernel_time_t;
typedef __kernel_long_t __kernel_clock_t;
typedef int __kernel_timer_t;
typedef int __kernel_clockid_t;
typedef char * __kernel_caddr_t;
typedef unsigned short __kernel_uid16_t;
typedef unsigned short __kernel_gid16_t;
# 39 "/home/shawn/source/linux/arch/arm/include/asm/posix_types.h" 2
# 48 "include/linux/posix_types.h" 2
# 18 "include/linux/types.h" 2



typedef __u32 __kernel_dev_t;

typedef __kernel_fd_set fd_set;
typedef __kernel_dev_t dev_t;
typedef __kernel_ino_t ino_t;
typedef __kernel_mode_t mode_t;
typedef unsigned short umode_t;
typedef __kernel_nlink_t nlink_t;
typedef __kernel_off_t off_t;
typedef __kernel_pid_t pid_t;
typedef __kernel_daddr_t daddr_t;
typedef __kernel_key_t key_t;
typedef __kernel_suseconds_t suseconds_t;
typedef __kernel_timer_t timer_t;
typedef __kernel_clockid_t clockid_t;
typedef __kernel_mqd_t mqd_t;

typedef _Bool bool;

typedef __kernel_uid32_t uid_t;
typedef __kernel_gid32_t gid_t;
typedef __kernel_uid16_t uid16_t;
typedef __kernel_gid16_t gid16_t;

typedef unsigned long uintptr_t;



typedef __kernel_old_uid_t old_uid_t;
typedef __kernel_old_gid_t old_gid_t;



typedef __kernel_loff_t loff_t;
# 63 "include/linux/types.h"
typedef __kernel_size_t size_t;




typedef __kernel_ssize_t ssize_t;




typedef __kernel_ptrdiff_t ptrdiff_t;




typedef __kernel_time_t time_t;




typedef __kernel_clock_t clock_t;




typedef __kernel_caddr_t caddr_t;



typedef unsigned char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;


typedef unsigned char unchar;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef unsigned long ulong;




typedef __u8 u_int8_t;
typedef __s8 int8_t;
typedef __u16 u_int16_t;
typedef __s16 int16_t;
typedef __u32 u_int32_t;
typedef __s32 int32_t;



typedef __u8 uint8_t;
typedef __u16 uint16_t;
typedef __u32 uint32_t;


typedef __u64 uint64_t;
typedef __u64 u_int64_t;
typedef __s64 int64_t;
# 139 "include/linux/types.h"
typedef u64 sector_t;
typedef u64 blkcnt_t;
# 157 "include/linux/types.h"
typedef u32 dma_addr_t;
# 178 "include/linux/types.h"
typedef __u16 __le16;
typedef __u16 __be16;
typedef __u32 __le32;
typedef __u32 __be32;
typedef __u64 __le64;
typedef __u64 __be64;

typedef __u16 __sum16;
typedef __u32 __wsum;
# 202 "include/linux/types.h"
typedef unsigned gfp_t;
typedef unsigned fmode_t;




typedef u32 phys_addr_t;


typedef phys_addr_t resource_size_t;





typedef unsigned long irq_hw_number_t;

typedef struct {
 int counter;
} atomic_t;







struct list_head {
 struct list_head *next, *prev;
};

struct hlist_head {
 struct hlist_node *first;
};

struct hlist_node {
 struct hlist_node *next, **pprev;
};

struct ustat {
 __kernel_daddr_t f_tfree;
 __kernel_ino_t f_tinode;
 char f_fname[6];
 char f_fpack[6];
};






struct rcu_head {
 struct rcu_head *next;
 void (*func)(struct rcu_head *head);
};
# 5 "arch/arm/boot/compressed/decompress.c" 2

# 1 "include/linux/linkage.h" 1




# 1 "/home/shawn/source/linux/arch/arm/include/asm/linkage.h" 1
# 6 "include/linux/linkage.h" 2
# 7 "arch/arm/boot/compressed/decompress.c" 2
# 1 "/home/shawn/source/linux/arch/arm/include/asm/string.h" 1
# 10 "/home/shawn/source/linux/arch/arm/include/asm/string.h"
extern char * strrchr(const char * s, int c);


extern char * strchr(const char * s, int c);


extern void * memcpy(void *, const void *, __kernel_size_t);


extern void * memmove(void *, const void *, __kernel_size_t);


extern void * memchr(const void *, int, __kernel_size_t);


extern void * memset(void *, int, __kernel_size_t);

extern void __memzero(void *ptr, __kernel_size_t n);
# 8 "arch/arm/boot/compressed/decompress.c" 2

extern unsigned long free_mem_ptr;
extern unsigned long free_mem_end_ptr;
extern void error(char *);
# 50 "arch/arm/boot/compressed/decompress.c"
# 1 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 1
# 107 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c"
# 1 "include/linux/decompress/mm.h" 1
# 30 "include/linux/decompress/mm.h"
 unsigned long malloc_ptr;
 int malloc_count;

static void *malloc(int size)
{
 void *p;

 if (size < 0)
  return ((void *)0);
 if (!malloc_ptr)
  malloc_ptr =3D free_mem_ptr;

 malloc_ptr =3D (malloc_ptr + 3) & ~3;

 p =3D (void *)malloc_ptr;
 malloc_ptr +=3D size;

 if (free_mem_end_ptr && malloc_ptr >=3D free_mem_end_ptr)
  return ((void *)0);

 malloc_count++;
 return p;
}

static void free(void *where)
{
 malloc_count--;
 if (!malloc_count)
  malloc_ptr =3D free_mem_ptr;
}
# 108 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 2
# 145 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c"
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h" 1
# 14 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h"
# 1 "include/linux/xz.h" 1
# 52 "include/linux/xz.h"
enum xz_mode {
 XZ_SINGLE,
 XZ_PREALLOC,
 XZ_DYNALLOC
};
# 108 "include/linux/xz.h"
enum xz_ret {
 XZ_OK,
 XZ_STREAM_END,
 XZ_UNSUPPORTED_CHECK,
 XZ_MEM_ERROR,
 XZ_MEMLIMIT_ERROR,
 XZ_FORMAT_ERROR,
 XZ_OPTIONS_ERROR,
 XZ_DATA_ERROR,
 XZ_BUF_ERROR
};
# 136 "include/linux/xz.h"
struct xz_buf {
 const uint8_t *in;
 size_t in_pos;
 size_t in_size;

 uint8_t *out;
 size_t out_pos;
 size_t out_size;
};




struct xz_dec;
# 194 "include/linux/xz.h"
static struct xz_dec *xz_dec_init(enum xz_mode mode, uint32_t dict_max);
# 214 "include/linux/xz.h"
static enum xz_ret xz_dec_run(struct xz_dec *s, struct xz_buf *b);
# 227 "include/linux/xz.h"
static void xz_dec_reset(struct xz_dec *s);






static void xz_dec_end(struct xz_dec *s);
# 255 "include/linux/xz.h"
static void xz_crc32_init(void);






static uint32_t xz_crc32(const uint8_t *buf, size_t size, uint32_t crc);
# 15 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h" 2
# 1 "include/linux/kernel.h" 1



# 1 "include/linux/sysinfo.h" 1






struct sysinfo {
 __kernel_long_t uptime;
 __kernel_ulong_t loads[3];
 __kernel_ulong_t totalram;
 __kernel_ulong_t freeram;
 __kernel_ulong_t sharedram;
 __kernel_ulong_t bufferram;
 __kernel_ulong_t totalswap;
 __kernel_ulong_t freeswap;
 __u16 procs;
 __u16 pad;
 __kernel_ulong_t totalhigh;
 __kernel_ulong_t freehigh;
 __u32 mem_unit;
 char _f[20-2*sizeof(__kernel_ulong_t)-sizeof(__u32)];
};
# 5 "include/linux/kernel.h" 2
# 14 "include/linux/kernel.h"
# 1 "/usr/lib/gcc/arm-linux-gnueabi/4.6/include/stdarg.h" 1 3 4
# 40 "/usr/lib/gcc/arm-linux-gnueabi/4.6/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 102 "/usr/lib/gcc/arm-linux-gnueabi/4.6/include/stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 15 "include/linux/kernel.h" 2




# 1 "include/linux/bitops.h" 1
# 13 "include/linux/bitops.h"
extern unsigned int __sw_hweight8(unsigned int w);
extern unsigned int __sw_hweight16(unsigned int w);
extern unsigned int __sw_hweight32(unsigned int w);
extern unsigned long __sw_hweight64(__u64 w);





# 1 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 1
# 27 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h"
# 1 "include/linux/irqflags.h" 1
# 14 "include/linux/irqflags.h"
# 1 "include/linux/typecheck.h" 1
# 15 "include/linux/irqflags.h" 2
# 1 "/home/shawn/source/linux/arch/arm/include/asm/irqflags.h" 1





# 1 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h" 1
# 13 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h"
# 1 "/home/shawn/source/linux/arch/arm/include/asm/hwcap.h" 1
# 35 "/home/shawn/source/linux/arch/arm/include/asm/hwcap.h"
extern unsigned int elf_hwcap;
# 14 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h" 2
# 108 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h"
struct pt_regs {
 unsigned long uregs[18];
};
# 166 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h"
static inline __attribute__((always_inline)) int valid_user_regs(struct pt_=
regs *regs)
{
 unsigned long mode =3D regs->uregs[16] & 0x0000001f;




 regs->uregs[16] &=3D ~(0x00000040 | 0x00000100);

 if ((regs->uregs[16] & 0x00000080) =3D=3D 0) {
  if (mode =3D=3D 0x00000010)
   return 1;
  if (elf_hwcap & (1 << 3) && mode =3D=3D 0x00000000)
   return 1;
 }




 regs->uregs[16] &=3D 0xff000000 | 0x00ff0000 | 0x0000ff00 | 0x00000020 | 0=
x00000010;
 if (!(elf_hwcap & (1 << 3)))
  regs->uregs[16] |=3D 0x00000010;

 return 0;
}

static inline __attribute__((always_inline)) long regs_return_value(struct =
pt_regs *regs)
{
 return regs->uregs[0];
}
# 223 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h"
extern int regs_query_register_offset(const char *name);
extern const char *regs_query_register_name(unsigned int offset);
extern bool regs_within_kernel_stack(struct pt_regs *regs, unsigned long ad=
dr);
extern unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
            unsigned int n);
# 238 "/home/shawn/source/linux/arch/arm/include/asm/ptrace.h"
static inline __attribute__((always_inline)) unsigned long regs_get_registe=
r(struct pt_regs *regs,
           unsigned int offset)
{
 if (__builtin_expect(!!(offset > (__builtin_offsetof(struct pt_regs,uregs[=
17]))), 0))
  return 0;
 return *(unsigned long *)((unsigned long)regs + offset);
}


static inline __attribute__((always_inline)) unsigned long kernel_stack_poi=
nter(struct pt_regs *regs)
{
 return regs->uregs[13];
}

static inline __attribute__((always_inline)) unsigned long user_stack_point=
er(struct pt_regs *regs)
{
 return regs->uregs[13];
}
# 7 "/home/shawn/source/linux/arch/arm/include/asm/irqflags.h" 2
# 49 "/home/shawn/source/linux/arch/arm/include/asm/irqflags.h"
static inline __attribute__((always_inline)) unsigned long arch_local_irq_s=
ave(void)
{
 unsigned long flags, temp;

 asm volatile(
  "	mrs	%0, cpsr	@ arch_local_irq_save\n"
  "	orr	%1, %0, #128\n"
  "	msr	cpsr_c, %1"
  : "=3Dr" (flags), "=3Dr" (temp)
  :
  : "memory", "cc");
 return flags;
}




static inline __attribute__((always_inline)) void arch_local_irq_enable(voi=
d)
{
 unsigned long temp;
 asm volatile(
  "	mrs	%0, cpsr	@ arch_local_irq_enable\n"
  "	bic	%0, %0, #128\n"
  "	msr	cpsr_c, %0"
  : "=3Dr" (temp)
  :
  : "memory", "cc");
}




static inline __attribute__((always_inline)) void arch_local_irq_disable(vo=
id)
{
 unsigned long temp;
 asm volatile(
  "	mrs	%0, cpsr	@ arch_local_irq_disable\n"
  "	orr	%0, %0, #128\n"
  "	msr	cpsr_c, %0"
  : "=3Dr" (temp)
  :
  : "memory", "cc");
}
# 128 "/home/shawn/source/linux/arch/arm/include/asm/irqflags.h"
static inline __attribute__((always_inline)) unsigned long arch_local_save_=
flags(void)
{
 unsigned long flags;
 asm volatile(
  "	mrs	%0, cpsr	@ local_save_flags"
  : "=3Dr" (flags) : : "memory", "cc");
 return flags;
}




static inline __attribute__((always_inline)) void arch_local_irq_restore(un=
signed long flags)
{
 asm volatile(
  "	msr	cpsr_c, %0	@ local_irq_restore"
  :
  : "r" (flags)
  : "memory", "cc");
}

static inline __attribute__((always_inline)) int arch_irqs_disabled_flags(u=
nsigned long flags)
{
 return flags & 0x00000080;
}
# 16 "include/linux/irqflags.h" 2
# 28 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2
# 37 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h"
static inline __attribute__((always_inline)) void ____atomic_set_bit(unsign=
ed int bit, volatile unsigned long *p)
{
 unsigned long flags;
 unsigned long mask =3D 1UL << (bit & 31);

 p +=3D bit >> 5;

 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0);
 *p |=3D mask;
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); arch_local_irq_restore(flags); } while (0);
}

static inline __attribute__((always_inline)) void ____atomic_clear_bit(unsi=
gned int bit, volatile unsigned long *p)
{
 unsigned long flags;
 unsigned long mask =3D 1UL << (bit & 31);

 p +=3D bit >> 5;

 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0);
 *p &=3D ~mask;
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); arch_local_irq_restore(flags); } while (0);
}

static inline __attribute__((always_inline)) void ____atomic_change_bit(uns=
igned int bit, volatile unsigned long *p)
{
 unsigned long flags;
 unsigned long mask =3D 1UL << (bit & 31);

 p +=3D bit >> 5;

 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0);
 *p ^=3D mask;
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); arch_local_irq_restore(flags); } while (0);
}

static inline __attribute__((always_inline)) int
____atomic_test_and_set_bit(unsigned int bit, volatile unsigned long *p)
{
 unsigned long flags;
 unsigned int res;
 unsigned long mask =3D 1UL << (bit & 31);

 p +=3D bit >> 5;

 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0);
 res =3D *p;
 *p =3D res | mask;
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); arch_local_irq_restore(flags); } while (0);

 return (res & mask) !=3D 0;
}

static inline __attribute__((always_inline)) int
____atomic_test_and_clear_bit(unsigned int bit, volatile unsigned long *p)
{
 unsigned long flags;
 unsigned int res;
 unsigned long mask =3D 1UL << (bit & 31);

 p +=3D bit >> 5;

 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0);
 res =3D *p;
 *p =3D res & ~mask;
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); arch_local_irq_restore(flags); } while (0);

 return (res & mask) !=3D 0;
}

static inline __attribute__((always_inline)) int
____atomic_test_and_change_bit(unsigned int bit, volatile unsigned long *p)
{
 unsigned long flags;
 unsigned int res;
 unsigned long mask =3D 1UL << (bit & 31);

 p +=3D bit >> 5;

 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); flags =3D arch_local_irq_save(); } while (0);
 res =3D *p;
 *p =3D res ^ mask;
 do { ({ unsigned long __dummy; typeof(flags) __dummy2; (void)(&__dummy =3D=
=3D &__dummy2); 1; }); arch_local_irq_restore(flags); } while (0);

 return (res & mask) !=3D 0;
}

# 1 "include/asm-generic/bitops/non-atomic.h" 1
# 15 "include/asm-generic/bitops/non-atomic.h"
static inline __attribute__((always_inline)) void __set_bit(int nr, volatil=
e unsigned long *addr)
{
 unsigned long mask =3D (1UL << ((nr) % 32));
 unsigned long *p =3D ((unsigned long *)addr) + ((nr) / 32);

 *p |=3D mask;
}

static inline __attribute__((always_inline)) void __clear_bit(int nr, volat=
ile unsigned long *addr)
{
 unsigned long mask =3D (1UL << ((nr) % 32));
 unsigned long *p =3D ((unsigned long *)addr) + ((nr) / 32);

 *p &=3D ~mask;
}
# 40 "include/asm-generic/bitops/non-atomic.h"
static inline __attribute__((always_inline)) void __change_bit(int nr, vola=
tile unsigned long *addr)
{
 unsigned long mask =3D (1UL << ((nr) % 32));
 unsigned long *p =3D ((unsigned long *)addr) + ((nr) / 32);

 *p ^=3D mask;
}
# 57 "include/asm-generic/bitops/non-atomic.h"
static inline __attribute__((always_inline)) int __test_and_set_bit(int nr,=
 volatile unsigned long *addr)
{
 unsigned long mask =3D (1UL << ((nr) % 32));
 unsigned long *p =3D ((unsigned long *)addr) + ((nr) / 32);
 unsigned long old =3D *p;

 *p =3D old | mask;
 return (old & mask) !=3D 0;
}
# 76 "include/asm-generic/bitops/non-atomic.h"
static inline __attribute__((always_inline)) int __test_and_clear_bit(int n=
r, volatile unsigned long *addr)
{
 unsigned long mask =3D (1UL << ((nr) % 32));
 unsigned long *p =3D ((unsigned long *)addr) + ((nr) / 32);
 unsigned long old =3D *p;

 *p =3D old & ~mask;
 return (old & mask) !=3D 0;
}


static inline __attribute__((always_inline)) int __test_and_change_bit(int =
nr,
         volatile unsigned long *addr)
{
 unsigned long mask =3D (1UL << ((nr) % 32));
 unsigned long *p =3D ((unsigned long *)addr) + ((nr) / 32);
 unsigned long old =3D *p;

 *p =3D old ^ mask;
 return (old & mask) !=3D 0;
}






static inline __attribute__((always_inline)) int test_bit(int nr, const vol=
atile unsigned long *addr)
{
 return 1UL & (addr[((nr) / 32)] >> (nr & (32 -1)));
}
# 125 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2
# 154 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h"
extern void _set_bit(int nr, volatile unsigned long * p);
extern void _clear_bit(int nr, volatile unsigned long * p);
extern void _change_bit(int nr, volatile unsigned long * p);
extern int _test_and_set_bit(int nr, volatile unsigned long * p);
extern int _test_and_clear_bit(int nr, volatile unsigned long * p);
extern int _test_and_change_bit(int nr, volatile unsigned long * p);




extern int _find_first_zero_bit_le(const void * p, unsigned size);
extern int _find_next_zero_bit_le(const void * p, int size, int offset);
extern int _find_first_bit_le(const unsigned long *p, unsigned size);
extern int _find_next_bit_le(const unsigned long *p, int size, int offset);




extern int _find_first_zero_bit_be(const void * p, unsigned size);
extern int _find_next_zero_bit_be(const void * p, int size, int offset);
extern int _find_first_bit_be(const unsigned long *p, unsigned size);
extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
# 227 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h"
static inline __attribute__((always_inline)) int constant_fls(int x)
{
 int r =3D 32;

 if (!x)
  return 0;
 if (!(x & 0xffff0000u)) {
  x <<=3D 16;
  r -=3D 16;
 }
 if (!(x & 0xff000000u)) {
  x <<=3D 8;
  r -=3D 8;
 }
 if (!(x & 0xf0000000u)) {
  x <<=3D 4;
  r -=3D 4;
 }
 if (!(x & 0xc0000000u)) {
  x <<=3D 2;
  r -=3D 2;
 }
 if (!(x & 0x80000000u)) {
  x <<=3D 1;
  r -=3D 1;
 }
 return r;
}






static inline __attribute__((always_inline)) int fls(int x)
{
 int ret;

 if (__builtin_constant_p(x))
        return constant_fls(x);

 asm("clz\t%0, %1" : "=3Dr" (ret) : "r" (x));
        ret =3D 32 - ret;
 return ret;
}
# 280 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h"
# 1 "include/asm-generic/bitops/fls64.h" 1
# 18 "include/asm-generic/bitops/fls64.h"
static inline __attribute__((always_inline)) __attribute__((always_inline))=
 int fls64(__u64 x)
{
 __u32 h =3D x >> 32;
 if (h)
  return fls(h) + 32;
 return fls(x);
}
# 281 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2

# 1 "include/asm-generic/bitops/sched.h" 1
# 12 "include/asm-generic/bitops/sched.h"
static inline __attribute__((always_inline)) int sched_find_first_bit(const=
 unsigned long *b)
{





 if (b[0])
  return (({ unsigned long __t =3D (b[0]); fls(__t & -__t); }) - 1);
 if (b[1])
  return (({ unsigned long __t =3D (b[1]); fls(__t & -__t); }) - 1) + 32;
 if (b[2])
  return (({ unsigned long __t =3D (b[2]); fls(__t & -__t); }) - 1) + 64;
 return (({ unsigned long __t =3D (b[3]); fls(__t & -__t); }) - 1) + 96;



}
# 283 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2
# 1 "include/asm-generic/bitops/hweight.h" 1



# 1 "include/asm-generic/bitops/arch_hweight.h" 1





static inline __attribute__((always_inline)) unsigned int __arch_hweight32(=
unsigned int w)
{
 return __sw_hweight32(w);
}

static inline __attribute__((always_inline)) unsigned int __arch_hweight16(=
unsigned int w)
{
 return __sw_hweight16(w);
}

static inline __attribute__((always_inline)) unsigned int __arch_hweight8(u=
nsigned int w)
{
 return __sw_hweight8(w);
}

static inline __attribute__((always_inline)) unsigned long __arch_hweight64=
(__u64 w)
{
 return __sw_hweight64(w);
}
# 5 "include/asm-generic/bitops/hweight.h" 2
# 1 "include/asm-generic/bitops/const_hweight.h" 1
# 6 "include/asm-generic/bitops/hweight.h" 2
# 284 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2
# 1 "include/asm-generic/bitops/lock.h" 1
# 285 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2
# 308 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h"
# 1 "include/asm-generic/bitops/le.h" 1




# 1 "/home/shawn/source/linux/arch/arm/include/asm/byteorder.h" 1
# 21 "/home/shawn/source/linux/arch/arm/include/asm/byteorder.h"
# 1 "include/linux/byteorder/little_endian.h" 1
# 12 "include/linux/byteorder/little_endian.h"
# 1 "include/linux/swab.h" 1





# 1 "/home/shawn/source/linux/arch/arm/include/asm/swab.h" 1
# 47 "/home/shawn/source/linux/arch/arm/include/asm/swab.h"
static inline __attribute__((always_inline)) __attribute__((__const__)) __u=
32 __arch_swab32(__u32 x)
{
 __u32 t;


 if (!__builtin_constant_p(x)) {





  asm ("eor\t%0, %1, %1, ror #16" : "=3Dr" (t) : "r" (x));
 } else

  t =3D x ^ ((x << 16) | (x >> 16));

 x =3D (x << 24) | (x >> 8);
 t &=3D ~0x00FF0000;
 x ^=3D (t >> 8);

 return x;
}
# 7 "include/linux/swab.h" 2
# 46 "include/linux/swab.h"
static inline __attribute__((always_inline)) __attribute__((__const__)) __u=
16 __fswab16(__u16 val)
{



 return ((__u16)( (((__u16)(val) & (__u16)0x00ffU) << 8) | (((__u16)(val) &=
 (__u16)0xff00U) >> 8)));

}

static inline __attribute__((always_inline)) __attribute__((__const__)) __u=
32 __fswab32(__u32 val)
{

 return __arch_swab32(val);



}

static inline __attribute__((always_inline)) __attribute__((__const__)) __u=
64 __fswab64(__u64 val)
{



 __u32 h =3D val >> 32;
 __u32 l =3D val & ((1ULL << 32) - 1);
 return (((__u64)__fswab32(l)) << 32) | ((__u64)(__fswab32(h)));



}

static inline __attribute__((always_inline)) __attribute__((__const__)) __u=
32 __fswahw32(__u32 val)
{



 return ((__u32)( (((__u32)(val) & (__u32)0x0000ffffUL) << 16) | (((__u32)(=
val) & (__u32)0xffff0000UL) >> 16)));

}

static inline __attribute__((always_inline)) __attribute__((__const__)) __u=
32 __fswahb32(__u32 val)
{



 return ((__u32)( (((__u32)(val) & (__u32)0x00ff00ffUL) << 8) | (((__u32)(v=
al) & (__u32)0xff00ff00UL) >> 8)));

}
# 148 "include/linux/swab.h"
static inline __attribute__((always_inline)) __u16 __swab16p(const __u16 *p=
)
{



 return (__builtin_constant_p((__u16)(*p)) ? ((__u16)( (((__u16)(*p) & (__u=
16)0x00ffU) << 8) | (((__u16)(*p) & (__u16)0xff00U) >> 8))) : __fswab16(*p)=
);

}





static inline __attribute__((always_inline)) __u32 __swab32p(const __u32 *p=
)
{



 return (__builtin_constant_p((__u32)(*p)) ? ((__u32)( (((__u32)(*p) & (__u=
32)0x000000ffUL) << 24) | (((__u32)(*p) & (__u32)0x0000ff00UL) << 8) | (((_=
_u32)(*p) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(*p) & (__u32)0xff000000U=
L) >> 24))) : __fswab32(*p));

}





static inline __attribute__((always_inline)) __u64 __swab64p(const __u64 *p=
)
{



 return (__builtin_constant_p((__u64)(*p)) ? ((__u64)( (((__u64)(*p) & (__u=
64)0x00000000000000ffULL) << 56) | (((__u64)(*p) & (__u64)0x000000000000ff0=
0ULL) << 40) | (((__u64)(*p) & (__u64)0x0000000000ff0000ULL) << 24) | (((__=
u64)(*p) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(*p) & (__u64)0x0=
00000ff00000000ULL) >> 8) | (((__u64)(*p) & (__u64)0x0000ff0000000000ULL) >=
> 24) | (((__u64)(*p) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(*p=
) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(*p));

}







static inline __attribute__((always_inline)) __u32 __swahw32p(const __u32 *=
p)
{



 return (__builtin_constant_p((__u32)(*p)) ? ((__u32)( (((__u32)(*p) & (__u=
32)0x0000ffffUL) << 16) | (((__u32)(*p) & (__u32)0xffff0000UL) >> 16))) : _=
_fswahw32(*p));

}







static inline __attribute__((always_inline)) __u32 __swahb32p(const __u32 *=
p)
{



 return (__builtin_constant_p((__u32)(*p)) ? ((__u32)( (((__u32)(*p) & (__u=
32)0x00ff00ffUL) << 8) | (((__u32)(*p) & (__u32)0xff00ff00UL) >> 8))) : __f=
swahb32(*p));

}





static inline __attribute__((always_inline)) void __swab16s(__u16 *p)
{



 *p =3D __swab16p(p);

}




static inline __attribute__((always_inline)) void __swab32s(__u32 *p)
{



 *p =3D __swab32p(p);

}





static inline __attribute__((always_inline)) void __swab64s(__u64 *p)
{



 *p =3D __swab64p(p);

}







static inline __attribute__((always_inline)) void __swahw32s(__u32 *p)
{



 *p =3D __swahw32p(p);

}







static inline __attribute__((always_inline)) void __swahb32s(__u32 *p)
{



 *p =3D __swahb32p(p);

}
# 13 "include/linux/byteorder/little_endian.h" 2
# 43 "include/linux/byteorder/little_endian.h"
static inline __attribute__((always_inline)) __le64 __cpu_to_le64p(const __=
u64 *p)
{
 return ( __le64)*p;
}
static inline __attribute__((always_inline)) __u64 __le64_to_cpup(const __l=
e64 *p)
{
 return ( __u64)*p;
}
static inline __attribute__((always_inline)) __le32 __cpu_to_le32p(const __=
u32 *p)
{
 return ( __le32)*p;
}
static inline __attribute__((always_inline)) __u32 __le32_to_cpup(const __l=
e32 *p)
{
 return ( __u32)*p;
}
static inline __attribute__((always_inline)) __le16 __cpu_to_le16p(const __=
u16 *p)
{
 return ( __le16)*p;
}
static inline __attribute__((always_inline)) __u16 __le16_to_cpup(const __l=
e16 *p)
{
 return ( __u16)*p;
}
static inline __attribute__((always_inline)) __be64 __cpu_to_be64p(const __=
u64 *p)
{
 return ( __be64)__swab64p(p);
}
static inline __attribute__((always_inline)) __u64 __be64_to_cpup(const __b=
e64 *p)
{
 return __swab64p((__u64 *)p);
}
static inline __attribute__((always_inline)) __be32 __cpu_to_be32p(const __=
u32 *p)
{
 return ( __be32)__swab32p(p);
}
static inline __attribute__((always_inline)) __u32 __be32_to_cpup(const __b=
e32 *p)
{
 return __swab32p((__u32 *)p);
}
static inline __attribute__((always_inline)) __be16 __cpu_to_be16p(const __=
u16 *p)
{
 return ( __be16)__swab16p(p);
}
static inline __attribute__((always_inline)) __u16 __be16_to_cpup(const __b=
e16 *p)
{
 return __swab16p((__u16 *)p);
}
# 105 "include/linux/byteorder/little_endian.h"
# 1 "include/linux/byteorder/generic.h" 1
# 143 "include/linux/byteorder/generic.h"
static inline __attribute__((always_inline)) void le16_add_cpu(__le16 *var,=
 u16 val)
{
 *var =3D (( __le16)(__u16)((( __u16)(__le16)(*var)) + val));
}

static inline __attribute__((always_inline)) void le32_add_cpu(__le32 *var,=
 u32 val)
{
 *var =3D (( __le32)(__u32)((( __u32)(__le32)(*var)) + val));
}

static inline __attribute__((always_inline)) void le64_add_cpu(__le64 *var,=
 u64 val)
{
 *var =3D (( __le64)(__u64)((( __u64)(__le64)(*var)) + val));
}

static inline __attribute__((always_inline)) void be16_add_cpu(__be16 *var,=
 u16 val)
{
 *var =3D (( __be16)(__builtin_constant_p((__u16)(((__builtin_constant_p((_=
_u16)(( __u16)(__be16)(*var))) ? ((__u16)( (((__u16)(( __u16)(__be16)(*var)=
) & (__u16)0x00ffU) << 8) | (((__u16)(( __u16)(__be16)(*var)) & (__u16)0xff=
00U) >> 8))) : __fswab16(( __u16)(__be16)(*var))) + val))) ? ((__u16)( (((_=
_u16)(((__builtin_constant_p((__u16)(( __u16)(__be16)(*var))) ? ((__u16)( (=
((__u16)(( __u16)(__be16)(*var)) & (__u16)0x00ffU) << 8) | (((__u16)(( __u1=
6)(__be16)(*var)) & (__u16)0xff00U) >> 8))) : __fswab16(( __u16)(__be16)(*v=
ar))) + val)) & (__u16)0x00ffU) << 8) | (((__u16)(((__builtin_constant_p((_=
_u16)(( __u16)(__be16)(*var))) ? ((__u16)( (((__u16)(( __u16)(__be16)(*var)=
) & (__u16)0x00ffU) << 8) | (((__u16)(( __u16)(__be16)(*var)) & (__u16)0xff=
00U) >> 8))) : __fswab16(( __u16)(__be16)(*var))) + val)) & (__u16)0xff00U)=
 >> 8))) : __fswab16(((__builtin_constant_p((__u16)(( __u16)(__be16)(*var))=
) ? ((__u16)( (((__u16)(( __u16)(__be16)(*var)) & (__u16)0x00ffU) << 8) | (=
((__u16)(( __u16)(__be16)(*var)) & (__u16)0xff00U) >> 8))) : __fswab16(( __=
u16)(__be16)(*var))) + val))));
}

static inline __attribute__((always_inline)) void be32_add_cpu(__be32 *var,=
 u32 val)
{
 *var =3D (( __be32)(__builtin_constant_p((__u32)(((__builtin_constant_p((_=
_u32)(( __u32)(__be32)(*var))) ? ((__u32)( (((__u32)(( __u32)(__be32)(*var)=
) & (__u32)0x000000ffUL) << 24) | (((__u32)(( __u32)(__be32)(*var)) & (__u3=
2)0x0000ff00UL) << 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x00ff00=
00UL) >> 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0xff000000UL) >> 2=
4))) : __fswab32(( __u32)(__be32)(*var))) + val))) ? ((__u32)( (((__u32)(((=
__builtin_constant_p((__u32)(( __u32)(__be32)(*var))) ? ((__u32)( (((__u32)=
(( __u32)(__be32)(*var)) & (__u32)0x000000ffUL) << 24) | (((__u32)(( __u32)=
(__be32)(*var)) & (__u32)0x0000ff00UL) << 8) | (((__u32)(( __u32)(__be32)(*=
var)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(( __u32)(__be32)(*var)) & (_=
_u32)0xff000000UL) >> 24))) : __fswab32(( __u32)(__be32)(*var))) + val)) & =
(__u32)0x000000ffUL) << 24) | (((__u32)(((__builtin_constant_p((__u32)(( __=
u32)(__be32)(*var))) ? ((__u32)( (((__u32)(( __u32)(__be32)(*var)) & (__u32=
)0x000000ffUL) << 24) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x0000ff=
00UL) << 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x00ff0000UL) >> 8=
) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0xff000000UL) >> 24))) : __f=
swab32(( __u32)(__be32)(*var))) + val)) & (__u32)0x0000ff00UL) << 8) | (((_=
_u32)(((__builtin_constant_p((__u32)(( __u32)(__be32)(*var))) ? ((__u32)( (=
((__u32)(( __u32)(__be32)(*var)) & (__u32)0x000000ffUL) << 24) | (((__u32)(=
( __u32)(__be32)(*var)) & (__u32)0x0000ff00UL) << 8) | (((__u32)(( __u32)(_=
_be32)(*var)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(( __u32)(__be32)(*va=
r)) & (__u32)0xff000000UL) >> 24))) : __fswab32(( __u32)(__be32)(*var))) + =
val)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(((__builtin_constant_p((__u3=
2)(( __u32)(__be32)(*var))) ? ((__u32)( (((__u32)(( __u32)(__be32)(*var)) &=
 (__u32)0x000000ffUL) << 24) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0=
x0000ff00UL) << 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x00ff0000U=
L) >> 8) | (((__u32)(( __u32)(__be32)(*var)) & (__u32)0xff000000UL) >> 24))=
) : __fswab32(( __u32)(__be32)(*var))) + val)) & (__u32)0xff000000UL) >> 24=
))) : __fswab32(((__builtin_constant_p((__u32)(( __u32)(__be32)(*var))) ? (=
(__u32)( (((__u32)(( __u32)(__be32)(*var)) & (__u32)0x000000ffUL) << 24) | =
(((__u32)(( __u32)(__be32)(*var)) & (__u32)0x0000ff00UL) << 8) | (((__u32)(=
( __u32)(__be32)(*var)) & (__u32)0x00ff0000UL) >> 8) | (((__u32)(( __u32)(_=
_be32)(*var)) & (__u32)0xff000000UL) >> 24))) : __fswab32(( __u32)(__be32)(=
*var))) + val))));
}

static inline __attribute__((always_inline)) void be64_add_cpu(__be64 *var,=
 u64 val)
{
 *var =3D (( __be64)(__builtin_constant_p((__u64)(((__builtin_constant_p((_=
_u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)=
) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var))=
 & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) =
& (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) =
& (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) =
& (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var)=
)) + val))) ? ((__u64)( (((__u64)(((__builtin_constant_p((__u64)(( __u64)(_=
_be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
00000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
0000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000=
00000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000=
00ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000f=
f0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff0=
00000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0xff000=
00000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)) & (__=
u64)0x00000000000000ffULL) << 56) | (((__u64)(((__builtin_constant_p((__u64=
)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & =
(__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (=
__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (_=
_u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (_=
_u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (_=
_u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) +=
 val)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(((__builtin_const=
ant_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be6=
4)(*var)) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64=
)(*var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)=
(*var)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)=
(*var)) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)=
(*var)) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be6=
4)(*var))) + val)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(((__b=
uiltin_constant_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( =
__u64)(__be64)(*var)) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( _=
_u64)(__be64)(*var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __=
u64)(__be64)(*var)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __=
u64)(__be64)(*var)) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __=
u64)(__be64)(*var)) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( =
__u64)(__be64)(*var))) + val)) & (__u64)0x00000000ff000000ULL) << 8) | (((_=
_u64)(((__builtin_constant_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000000000ffULL) << 56) | (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000000000ff00ULL) << 40) | (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (=
((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000ff000000ULL) << 8) | ((=
(__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((=
__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((=
__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff000000000000ULL) >> 40) | (((=
__u64)(( __u64)(__be64)(*var)) & (__u64)0xff00000000000000ULL) >> 56))) : _=
_fswab64(( __u64)(__be64)(*var))) + val)) & (__u64)0x000000ff00000000ULL) >=
> 8) | (((__u64)(((__builtin_constant_p((__u64)(( __u64)(__be64)(*var))) ? =
((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000000000ffULL)=
 << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000000000ff00ULL)=
 << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000000000ff0000ULL)=
 << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000ff000000ULL)=
 << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000ff00000000ULL) =
>> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000ff0000000000ULL) >=
> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff000000000000ULL) >=
> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0xff00000000000000ULL) >=
> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)) & (__u64)0x0000ff00000=
00000ULL) >> 24) | (((__u64)(((__builtin_constant_p((__u64)(( __u64)(__be64=
)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
0000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
00ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00000000=
ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x000000ff0=
0000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x0000ff0000=
000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0x00ff000000=
000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)0xff00000000=
000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)) & (__u64)0=
x00ff000000000000ULL) >> 40) | (((__u64)(((__builtin_constant_p((__u64)(( _=
_u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u6=
4)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64=
)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)=
0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)=
0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*var)) & (__u64)=
0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(*var))) + val)=
) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(((__builtin_constant=
_p((__u64)(( __u64)(__be64)(*var))) ? ((__u64)( (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x00000000000000ffULL) << 56) | (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x000000000000ff00ULL) << 40) | (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x0000000000ff0000ULL) << 24) | (((__u64)(( __u64)(__be64)(=
*var)) & (__u64)0x00000000ff000000ULL) << 8) | (((__u64)(( __u64)(__be64)(*=
var)) & (__u64)0x000000ff00000000ULL) >> 8) | (((__u64)(( __u64)(__be64)(*v=
ar)) & (__u64)0x0000ff0000000000ULL) >> 24) | (((__u64)(( __u64)(__be64)(*v=
ar)) & (__u64)0x00ff000000000000ULL) >> 40) | (((__u64)(( __u64)(__be64)(*v=
ar)) & (__u64)0xff00000000000000ULL) >> 56))) : __fswab64(( __u64)(__be64)(=
*var))) + val))));
}
# 106 "include/linux/byteorder/little_endian.h" 2
# 22 "/home/shawn/source/linux/arch/arm/include/asm/byteorder.h" 2
# 6 "include/asm-generic/bitops/le.h" 2





static inline __attribute__((always_inline)) unsigned long find_next_zero_b=
it_le(const void *addr,
  unsigned long size, unsigned long offset)
{
 return _find_next_zero_bit_le(addr,size,offset);
}

static inline __attribute__((always_inline)) unsigned long find_next_bit_le=
(const void *addr,
  unsigned long size, unsigned long offset)
{
 return _find_next_bit_le(addr,size,offset);
}

static inline __attribute__((always_inline)) unsigned long find_first_zero_=
bit_le(const void *addr,
  unsigned long size)
{
 return _find_first_zero_bit_le(addr,size);
}
# 52 "include/asm-generic/bitops/le.h"
static inline __attribute__((always_inline)) int test_bit_le(int nr, const =
void *addr)
{
 return test_bit(nr ^ 0, addr);
}

static inline __attribute__((always_inline)) void __set_bit_le(int nr, void=
 *addr)
{
 __set_bit(nr ^ 0, addr);
}

static inline __attribute__((always_inline)) void __clear_bit_le(int nr, vo=
id *addr)
{
 __clear_bit(nr ^ 0, addr);
}

static inline __attribute__((always_inline)) int test_and_set_bit_le(int nr=
, void *addr)
{
 return (__builtin_constant_p(nr ^ 0) ? ____atomic_test_and_set_bit(nr ^ 0,=
 addr) : _test_and_set_bit(nr ^ 0,addr));
}

static inline __attribute__((always_inline)) int test_and_clear_bit_le(int =
nr, void *addr)
{
 return (__builtin_constant_p(nr ^ 0) ? ____atomic_test_and_clear_bit(nr ^ =
0, addr) : _test_and_clear_bit(nr ^ 0,addr));
}

static inline __attribute__((always_inline)) int __test_and_set_bit_le(int =
nr, void *addr)
{
 return __test_and_set_bit(nr ^ 0, addr);
}

static inline __attribute__((always_inline)) int __test_and_clear_bit_le(in=
t nr, void *addr)
{
 return __test_and_clear_bit(nr ^ 0, addr);
}
# 309 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2




# 1 "include/asm-generic/bitops/ext2-atomic-setbit.h" 1
# 314 "/home/shawn/source/linux/arch/arm/include/asm/bitops.h" 2
# 23 "include/linux/bitops.h" 2
# 46 "include/linux/bitops.h"
static __inline__ __attribute__((always_inline)) int get_bitmask_order(unsi=
gned int count)
{
 int order;

 order =3D fls(count);
 return order;
}

static __inline__ __attribute__((always_inline)) int get_count_order(unsign=
ed int count)
{
 int order;

 order =3D fls(count) - 1;
 if (count & (count - 1))
  order++;
 return order;
}

static inline __attribute__((always_inline)) unsigned long hweight_long(uns=
igned long w)
{
 return sizeof(w) =3D=3D 4 ? (__builtin_constant_p(w) ? ((( (!!((w) & (1ULL=
 << 0))) + (!!((w) & (1ULL << 1))) + (!!((w) & (1ULL << 2))) + (!!((w) & (1=
ULL << 3))) + (!!((w) & (1ULL << 4))) + (!!((w) & (1ULL << 5))) + (!!((w) &=
 (1ULL << 6))) + (!!((w) & (1ULL << 7))) ) + ( (!!(((w) >> 8) & (1ULL << 0)=
)) + (!!(((w) >> 8) & (1ULL << 1))) + (!!(((w) >> 8) & (1ULL << 2))) + (!!(=
((w) >> 8) & (1ULL << 3))) + (!!(((w) >> 8) & (1ULL << 4))) + (!!(((w) >> 8=
) & (1ULL << 5))) + (!!(((w) >> 8) & (1ULL << 6))) + (!!(((w) >> 8) & (1ULL=
 << 7))) )) + (( (!!(((w) >> 16) & (1ULL << 0))) + (!!(((w) >> 16) & (1ULL =
<< 1))) + (!!(((w) >> 16) & (1ULL << 2))) + (!!(((w) >> 16) & (1ULL << 3)))=
 + (!!(((w) >> 16) & (1ULL << 4))) + (!!(((w) >> 16) & (1ULL << 5))) + (!!(=
((w) >> 16) & (1ULL << 6))) + (!!(((w) >> 16) & (1ULL << 7))) ) + ( (!!((((=
w) >> 16) >> 8) & (1ULL << 0))) + (!!((((w) >> 16) >> 8) & (1ULL << 1))) + =
(!!((((w) >> 16) >> 8) & (1ULL << 2))) + (!!((((w) >> 16) >> 8) & (1ULL << =
3))) + (!!((((w) >> 16) >> 8) & (1ULL << 4))) + (!!((((w) >> 16) >> 8) & (1=
ULL << 5))) + (!!((((w) >> 16) >> 8) & (1ULL << 6))) + (!!((((w) >> 16) >> =
8) & (1ULL << 7))) ))) : __arch_hweight32(w)) : (__builtin_constant_p(w) ? =
(((( (!!((w) & (1ULL << 0))) + (!!((w) & (1ULL << 1))) + (!!((w) & (1ULL <<=
 2))) + (!!((w) & (1ULL << 3))) + (!!((w) & (1ULL << 4))) + (!!((w) & (1ULL=
 << 5))) + (!!((w) & (1ULL << 6))) + (!!((w) & (1ULL << 7))) ) + ( (!!(((w)=
 >> 8) & (1ULL << 0))) + (!!(((w) >> 8) & (1ULL << 1))) + (!!(((w) >> 8) & =
(1ULL << 2))) + (!!(((w) >> 8) & (1ULL << 3))) + (!!(((w) >> 8) & (1ULL << =
4))) + (!!(((w) >> 8) & (1ULL << 5))) + (!!(((w) >> 8) & (1ULL << 6))) + (!=
!(((w) >> 8) & (1ULL << 7))) )) + (( (!!(((w) >> 16) & (1ULL << 0))) + (!!(=
((w) >> 16) & (1ULL << 1))) + (!!(((w) >> 16) & (1ULL << 2))) + (!!(((w) >>=
 16) & (1ULL << 3))) + (!!(((w) >> 16) & (1ULL << 4))) + (!!(((w) >> 16) & =
(1ULL << 5))) + (!!(((w) >> 16) & (1ULL << 6))) + (!!(((w) >> 16) & (1ULL <=
< 7))) ) + ( (!!((((w) >> 16) >> 8) & (1ULL << 0))) + (!!((((w) >> 16) >> 8=
) & (1ULL << 1))) + (!!((((w) >> 16) >> 8) & (1ULL << 2))) + (!!((((w) >> 1=
6) >> 8) & (1ULL << 3))) + (!!((((w) >> 16) >> 8) & (1ULL << 4))) + (!!((((=
w) >> 16) >> 8) & (1ULL << 5))) + (!!((((w) >> 16) >> 8) & (1ULL << 6))) + =
(!!((((w) >> 16) >> 8) & (1ULL << 7))) ))) + ((( (!!(((w) >> 32) & (1ULL <<=
 0))) + (!!(((w) >> 32) & (1ULL << 1))) + (!!(((w) >> 32) & (1ULL << 2))) +=
 (!!(((w) >> 32) & (1ULL << 3))) + (!!(((w) >> 32) & (1ULL << 4))) + (!!(((=
w) >> 32) & (1ULL << 5))) + (!!(((w) >> 32) & (1ULL << 6))) + (!!(((w) >> 3=
2) & (1ULL << 7))) ) + ( (!!((((w) >> 32) >> 8) & (1ULL << 0))) + (!!((((w)=
 >> 32) >> 8) & (1ULL << 1))) + (!!((((w) >> 32) >> 8) & (1ULL << 2))) + (!=
!((((w) >> 32) >> 8) & (1ULL << 3))) + (!!((((w) >> 32) >> 8) & (1ULL << 4)=
)) + (!!((((w) >> 32) >> 8) & (1ULL << 5))) + (!!((((w) >> 32) >> 8) & (1UL=
L << 6))) + (!!((((w) >> 32) >> 8) & (1ULL << 7))) )) + (( (!!((((w) >> 32)=
 >> 16) & (1ULL << 0))) + (!!((((w) >> 32) >> 16) & (1ULL << 1))) + (!!((((=
w) >> 32) >> 16) & (1ULL << 2))) + (!!((((w) >> 32) >> 16) & (1ULL << 3))) =
+ (!!((((w) >> 32) >> 16) & (1ULL << 4))) + (!!((((w) >> 32) >> 16) & (1ULL=
 << 5))) + (!!((((w) >> 32) >> 16) & (1ULL << 6))) + (!!((((w) >> 32) >> 16=
) & (1ULL << 7))) ) + ( (!!(((((w) >> 32) >> 16) >> 8) & (1ULL << 0))) + (!=
!(((((w) >> 32) >> 16) >> 8) & (1ULL << 1))) + (!!(((((w) >> 32) >> 16) >> =
8) & (1ULL << 2))) + (!!(((((w) >> 32) >> 16) >> 8) & (1ULL << 3))) + (!!((=
(((w) >> 32) >> 16) >> 8) & (1ULL << 4))) + (!!(((((w) >> 32) >> 16) >> 8) =
& (1ULL << 5))) + (!!(((((w) >> 32) >> 16) >> 8) & (1ULL << 6))) + (!!(((((=
w) >> 32) >> 16) >> 8) & (1ULL << 7))) )))) : __arch_hweight64(w));
}






static inline __attribute__((always_inline)) __u64 rol64(__u64 word, unsign=
ed int shift)
{
 return (word << shift) | (word >> (64 - shift));
}






static inline __attribute__((always_inline)) __u64 ror64(__u64 word, unsign=
ed int shift)
{
 return (word >> shift) | (word << (64 - shift));
}






static inline __attribute__((always_inline)) __u32 rol32(__u32 word, unsign=
ed int shift)
{
 return (word << shift) | (word >> (32 - shift));
}






static inline __attribute__((always_inline)) __u32 ror32(__u32 word, unsign=
ed int shift)
{
 return (word >> shift) | (word << (32 - shift));
}






static inline __attribute__((always_inline)) __u16 rol16(__u16 word, unsign=
ed int shift)
{
 return (word << shift) | (word >> (16 - shift));
}






static inline __attribute__((always_inline)) __u16 ror16(__u16 word, unsign=
ed int shift)
{
 return (word >> shift) | (word << (16 - shift));
}






static inline __attribute__((always_inline)) __u8 rol8(__u8 word, unsigned =
int shift)
{
 return (word << shift) | (word >> (8 - shift));
}






static inline __attribute__((always_inline)) __u8 ror8(__u8 word, unsigned =
int shift)
{
 return (word >> shift) | (word << (8 - shift));
}






static inline __attribute__((always_inline)) __s32 sign_extend32(__u32 valu=
e, int index)
{
 __u8 shift =3D 31 - index;
 return (__s32)(value << shift) >> shift;
}

static inline __attribute__((always_inline)) unsigned fls_long(unsigned lon=
g l)
{
 if (sizeof(l) =3D=3D 4)
  return fls(l);
 return fls64(l);
}
# 175 "include/linux/bitops.h"
static inline __attribute__((always_inline)) unsigned long __ffs64(u64 word=
)
{

 if (((u32)word) =3D=3D 0UL)
  return (({ unsigned long __t =3D ((u32)(word >> 32)); fls(__t & -__t); })=
 - 1) + 32;



 return (({ unsigned long __t =3D ((unsigned long)word); fls(__t & -__t); }=
) - 1);
}
# 196 "include/linux/bitops.h"
extern unsigned long find_last_bit(const unsigned long *addr,
       unsigned long size);
# 20 "include/linux/kernel.h" 2
# 1 "include/linux/log2.h" 1
# 21 "include/linux/log2.h"
extern __attribute__((const, noreturn))
int ____ilog2_NaN(void);
# 31 "include/linux/log2.h"
static inline __attribute__((always_inline)) __attribute__((const))
int __ilog2_u32(u32 n)
{
 return fls(n) - 1;
}



static inline __attribute__((always_inline)) __attribute__((const))
int __ilog2_u64(u64 n)
{
 return fls64(n) - 1;
}







static inline __attribute__((always_inline)) __attribute__((const))
bool is_power_of_2(unsigned long n)
{
 return (n !=3D 0 && ((n & (n - 1)) =3D=3D 0));
}




static inline __attribute__((always_inline)) __attribute__((const))
unsigned long __roundup_pow_of_two(unsigned long n)
{
 return 1UL << fls_long(n - 1);
}




static inline __attribute__((always_inline)) __attribute__((const))
unsigned long __rounddown_pow_of_two(unsigned long n)
{
 return 1UL << (fls_long(n) - 1);
}
# 21 "include/linux/kernel.h" 2

# 1 "include/linux/printk.h" 1



# 1 "include/linux/init.h" 1
# 139 "include/linux/init.h"
typedef int (*initcall_t)(void);
typedef void (*exitcall_t)(void);

extern initcall_t __con_initcall_start[], __con_initcall_end[];
extern initcall_t __security_initcall_start[], __security_initcall_end[];


typedef void (*ctor_fn_t)(void);


extern int do_one_initcall(initcall_t fn);
extern char __attribute__ ((__section__(".init.data"))) boot_command_line[]=
;
extern char *saved_command_line;
extern unsigned int reset_devices;


void setup_arch(char **);
void prepare_namespace(void);

extern void (*late_time_init)(void);

extern bool initcall_debug;
# 226 "include/linux/init.h"
struct obs_kernel_param {
 const char *str;
 int (*setup_func)(char *);
 int early;
};
# 255 "include/linux/init.h"
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) parse_early_param(void);
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) parse_early_options(char *cmdline);
# 5 "include/linux/printk.h" 2

extern const char linux_banner[];
extern const char linux_proc_banner[];
# 27 "include/linux/printk.h"
extern int console_printk[];






static inline __attribute__((always_inline)) void console_silent(void)
{
 (console_printk[0]) =3D 0;
}

static inline __attribute__((always_inline)) void console_verbose(void)
{
 if ((console_printk[0]))
  (console_printk[0]) =3D 15;
}

struct va_format {
 const char *fmt;
 va_list *va;
};
# 85 "include/linux/printk.h"
static inline __attribute__((always_inline)) __attribute__((format(printf, =
1, 2)))
int no_printk(const char *fmt, ...)
{
 return 0;
}

extern __attribute__((format(printf, 1, 2)))
void early_printk(const char *fmt, ...);

extern int printk_needs_cpu(int cpu);
extern void printk_tick(void);


 __attribute__((format(printf, 5, 0)))
int vprintk_emit(int facility, int level,
   const char *dict, size_t dictlen,
   const char *fmt, va_list args);

 __attribute__((format(printf, 1, 0)))
int vprintk(const char *fmt, va_list args);

 __attribute__((format(printf, 5, 6))) __attribute__((__cold__))
 int printk_emit(int facility, int level,
      const char *dict, size_t dictlen,
      const char *fmt, ...);

 __attribute__((format(printf, 1, 2))) __attribute__((__cold__))
int printk(const char *fmt, ...);




__attribute__((format(printf, 1, 2))) __attribute__((__cold__)) int printk_=
sched(const char *fmt, ...);






extern int __printk_ratelimit(const char *func);

extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
       unsigned int interval_msec);

extern int printk_delay_msec;
extern int dmesg_restrict;
extern int kptr_restrict;

void log_buf_kexec_setup(void);
void __attribute__ ((__section__(".init.text"))) __attribute__((__cold__)) =
__attribute__((no_instrument_function)) setup_log_buf(int early);
# 170 "include/linux/printk.h"
extern void dump_stack(void) __attribute__((__cold__));
# 303 "include/linux/printk.h"
extern const struct file_operations kmsg_fops;

enum {
 DUMP_PREFIX_NONE,
 DUMP_PREFIX_ADDRESS,
 DUMP_PREFIX_OFFSET
};
extern void hex_dump_to_buffer(const void *buf, size_t len,
          int rowsize, int groupsize,
          char *linebuf, size_t linebuflen, bool ascii);

extern void print_hex_dump(const char *level, const char *prefix_str,
      int prefix_type, int rowsize, int groupsize,
      const void *buf, size_t len, bool ascii);
extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
     const void *buf, size_t len);
# 23 "include/linux/kernel.h" 2
# 1 "include/linux/dynamic_debug.h" 1
# 9 "include/linux/dynamic_debug.h"
struct _ddebug {




 const char *modname;
 const char *function;
 const char *filename;
 const char *format;
 unsigned int lineno:18;
# 35 "include/linux/dynamic_debug.h"
 unsigned int flags:8;
} __attribute__((aligned(8)));


int ddebug_add_module(struct _ddebug *tab, unsigned int n,
    const char *modname);
# 100 "include/linux/dynamic_debug.h"
# 1 "include/linux/string.h" 1
# 101 "include/linux/dynamic_debug.h" 2
# 1 "include/linux/errno.h" 1



# 1 "arch/arm/include/generated/asm/errno.h" 1
# 1 "include/asm-generic/errno.h" 1



# 1 "include/asm-generic/errno-base.h" 1
# 5 "include/asm-generic/errno.h" 2
# 1 "arch/arm/include/generated/asm/errno.h" 2
# 5 "include/linux/errno.h" 2
# 102 "include/linux/dynamic_debug.h" 2

static inline __attribute__((always_inline)) int ddebug_remove_module(const=
 char *mod)
{
 return 0;
}

static inline __attribute__((always_inline)) int ddebug_dyndbg_module_param=
_cb(char *param, char *val,
      const char *modname)
{
 if (strstr(param, "dyndbg")) {

  printk("<4>" "dyndbg param is supported only in "
   "CONFIG_DYNAMIC_DEBUG builds\n");
  return 0;
 }
 return -22;
}
# 24 "include/linux/kernel.h" 2
# 108 "include/linux/kernel.h"
# 1 "/home/shawn/source/linux/arch/arm/include/asm/div64.h" 1




# 1 "/home/shawn/source/linux/arch/arm/include/asm/compiler.h" 1
# 6 "/home/shawn/source/linux/arch/arm/include/asm/div64.h" 2
# 63 "/home/shawn/source/linux/arch/arm/include/asm/div64.h"
# 1 "/home/shawn/source/linux/arch/arm/include/asm/bug.h" 1
# 59 "/home/shawn/source/linux/arch/arm/include/asm/bug.h"
# 1 "include/asm-generic/bug.h" 1
# 10 "include/asm-generic/bug.h"
struct bug_entry {

 unsigned long bug_addr;





 const char *file;



 unsigned short line;

 unsigned short flags;
};
# 64 "include/asm-generic/bug.h"
extern __attribute__((format(printf, 3, 4)))
void warn_slowpath_fmt(const char *file, const int line,
         const char *fmt, ...);
extern __attribute__((format(printf, 4, 5)))
void warn_slowpath_fmt_taint(const char *file, const int line, unsigned tai=
nt,
        const char *fmt, ...);
extern void warn_slowpath_null(const char *file, const int line);
# 60 "/home/shawn/source/linux/arch/arm/include/asm/bug.h" 2

struct pt_regs;
void die(const char *msg, struct pt_regs *regs, int err);

struct siginfo;
void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *=
info,
  unsigned long err, unsigned long trap);
# 76 "/home/shawn/source/linux/arch/arm/include/asm/bug.h"
void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
           struct pt_regs *),
       int sig, int code, const char *name);

void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
           struct pt_regs *),
       int sig, int code, const char *name);

extern void c_backtrace(unsigned long fp, int pmode);

struct mm_struct;
extern void show_pte(struct mm_struct *mm, unsigned long addr);
extern void __show_regs(struct pt_regs *);
# 64 "/home/shawn/source/linux/arch/arm/include/asm/div64.h" 2
# 109 "include/linux/kernel.h" 2
# 137 "include/linux/kernel.h"
struct completion;
struct pt_regs;
struct user;
# 163 "include/linux/kernel.h"
  static inline __attribute__((always_inline)) void __might_sleep(const cha=
r *file, int line,
       int preempt_offset) { }
# 196 "include/linux/kernel.h"
static inline __attribute__((always_inline)) void might_fault(void)
{
 do { do { } while (0); } while (0);
}


extern struct atomic_notifier_head panic_notifier_list;
extern long (*panic_blink)(int state);
__attribute__((format(printf, 1, 2)))
void panic(const char *fmt, ...)
 __attribute__((noreturn)) __attribute__((__cold__));
extern void oops_enter(void);
extern void oops_exit(void);
void print_oops_end_marker(void);
extern int oops_may_print(void);
void do_exit(long error_code)
 __attribute__((noreturn));
void complete_and_exit(struct completion *, long)
 __attribute__((noreturn));


int __attribute__((warn_unused_result)) _kstrtoul(const char *s, unsigned i=
nt base, unsigned long *res);
int __attribute__((warn_unused_result)) _kstrtol(const char *s, unsigned in=
t base, long *res);

int __attribute__((warn_unused_result)) kstrtoull(const char *s, unsigned i=
nt base, unsigned long long *res);
int __attribute__((warn_unused_result)) kstrtoll(const char *s, unsigned in=
t base, long long *res);
static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtoul(const char *s, unsigned int base, unsigned long *res)
{




 if (sizeof(unsigned long) =3D=3D sizeof(unsigned long long) &&
     __alignof__(unsigned long) =3D=3D __alignof__(unsigned long long))
  return kstrtoull(s, base, (unsigned long long *)res);
 else
  return _kstrtoul(s, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtol(const char *s, unsigned int base, long *res)
{




 if (sizeof(long) =3D=3D sizeof(long long) &&
     __alignof__(long) =3D=3D __alignof__(long long))
  return kstrtoll(s, base, (long long *)res);
 else
  return _kstrtol(s, base, res);
}

int __attribute__((warn_unused_result)) kstrtouint(const char *s, unsigned =
int base, unsigned int *res);
int __attribute__((warn_unused_result)) kstrtoint(const char *s, unsigned i=
nt base, int *res);

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtou64(const char *s, unsigned int base, u64 *res)
{
 return kstrtoull(s, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtos64(const char *s, unsigned int base, s64 *res)
{
 return kstrtoll(s, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtou32(const char *s, unsigned int base, u32 *res)
{
 return kstrtouint(s, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtos32(const char *s, unsigned int base, s32 *res)
{
 return kstrtoint(s, base, res);
}

int __attribute__((warn_unused_result)) kstrtou16(const char *s, unsigned i=
nt base, u16 *res);
int __attribute__((warn_unused_result)) kstrtos16(const char *s, unsigned i=
nt base, s16 *res);
int __attribute__((warn_unused_result)) kstrtou8(const char *s, unsigned in=
t base, u8 *res);
int __attribute__((warn_unused_result)) kstrtos8(const char *s, unsigned in=
t base, s8 *res);

int __attribute__((warn_unused_result)) kstrtoull_from_user(const char *s, =
size_t count, unsigned int base, unsigned long long *res);
int __attribute__((warn_unused_result)) kstrtoll_from_user(const char *s, s=
ize_t count, unsigned int base, long long *res);
int __attribute__((warn_unused_result)) kstrtoul_from_user(const char *s, s=
ize_t count, unsigned int base, unsigned long *res);
int __attribute__((warn_unused_result)) kstrtol_from_user(const char *s, si=
ze_t count, unsigned int base, long *res);
int __attribute__((warn_unused_result)) kstrtouint_from_user(const char *s,=
 size_t count, unsigned int base, unsigned int *res);
int __attribute__((warn_unused_result)) kstrtoint_from_user(const char *s, =
size_t count, unsigned int base, int *res);
int __attribute__((warn_unused_result)) kstrtou16_from_user(const char *s, =
size_t count, unsigned int base, u16 *res);
int __attribute__((warn_unused_result)) kstrtos16_from_user(const char *s, =
size_t count, unsigned int base, s16 *res);
int __attribute__((warn_unused_result)) kstrtou8_from_user(const char *s, s=
ize_t count, unsigned int base, u8 *res);
int __attribute__((warn_unused_result)) kstrtos8_from_user(const char *s, s=
ize_t count, unsigned int base, s8 *res);

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtou64_from_user(const char *s, size_t count, unsigned int bas=
e, u64 *res)
{
 return kstrtoull_from_user(s, count, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtos64_from_user(const char *s, size_t count, unsigned int bas=
e, s64 *res)
{
 return kstrtoll_from_user(s, count, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtou32_from_user(const char *s, size_t count, unsigned int bas=
e, u32 *res)
{
 return kstrtouint_from_user(s, count, base, res);
}

static inline __attribute__((always_inline)) int __attribute__((warn_unused=
_result)) kstrtos32_from_user(const char *s, size_t count, unsigned int bas=
e, s32 *res)
{
 return kstrtoint_from_user(s, count, base, res);
}



extern unsigned long simple_strtoul(const char *,char **,unsigned int);
extern long simple_strtol(const char *,char **,unsigned int);
extern unsigned long long simple_strtoull(const char *,char **,unsigned int=
);
extern long long simple_strtoll(const char *,char **,unsigned int);





extern int num_to_str(char *buf, int size, unsigned long long num);



extern __attribute__((format(printf, 2, 3))) int sprintf(char *buf, const c=
har * fmt, ...);
extern __attribute__((format(printf, 2, 0))) int vsprintf(char *buf, const =
char *, va_list);
extern __attribute__((format(printf, 3, 4)))
int snprintf(char *buf, size_t size, const char *fmt, ...);
extern __attribute__((format(printf, 3, 0)))
int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
extern __attribute__((format(printf, 3, 4)))
int scnprintf(char *buf, size_t size, const char *fmt, ...);
extern __attribute__((format(printf, 3, 0)))
int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
extern __attribute__((format(printf, 2, 3)))
char *kasprintf(gfp_t gfp, const char *fmt, ...);
extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);

extern __attribute__((format(scanf, 2, 3)))
int sscanf(const char *, const char *, ...);
extern __attribute__((format(scanf, 2, 0)))
int vsscanf(const char *, const char *, va_list);

extern int get_option(char **str, int *pint);
extern char *get_options(const char *str, int nints, int *ints);
extern unsigned long long memparse(const char *ptr, char **retptr);

extern int core_kernel_text(unsigned long addr);
extern int core_kernel_data(unsigned long addr);
extern int __kernel_text_address(unsigned long addr);
extern int kernel_text_address(unsigned long addr);
extern int func_ptr_is_kernel_text(void *ptr);

struct pid;
extern struct pid *session_of_pgrp(struct pid *pgrp);

unsigned long int_sqrt(unsigned long);

extern void bust_spinlocks(int yes);
extern void wake_up_klogd(void);
extern int oops_in_progress;
extern int panic_timeout;
extern int panic_on_oops;
extern int panic_on_unrecovered_nmi;
extern int panic_on_io_nmi;
extern int sysctl_panic_on_stackoverflow;
extern const char *print_tainted(void);
extern void add_taint(unsigned flag);
extern int test_taint(unsigned flag);
extern unsigned long get_taint(void);
extern int root_mountflags;

extern bool early_boot_irqs_disabled;


extern enum system_states {
 SYSTEM_BOOTING,
 SYSTEM_RUNNING,
 SYSTEM_HALT,
 SYSTEM_POWER_OFF,
 SYSTEM_RESTART,
 SYSTEM_SUSPEND_DISK,
} system_state;
# 396 "include/linux/kernel.h"
extern const char hex_asc[];



static inline __attribute__((always_inline)) char *hex_byte_pack(char *buf,=
 u8 byte)
{
 *buf++ =3D hex_asc[((byte) & 0xf0) >> 4];
 *buf++ =3D hex_asc[((byte) & 0x0f)];
 return buf;
}

static inline __attribute__((always_inline)) char * __attribute__((deprecat=
ed)) pack_hex_byte(char *buf, u8 byte)
{
 return hex_byte_pack(buf, byte);
}

extern int hex_to_bin(char ch);
extern int __attribute__((warn_unused_result)) hex2bin(u8 *dst, const char =
*src, size_t count);
# 436 "include/linux/kernel.h"
void tracing_off_permanent(void);




enum ftrace_dump_mode {
 DUMP_NONE,
 DUMP_ALL,
 DUMP_ORIG,
};


void tracing_on(void);
void tracing_off(void);
int tracing_is_on(void);

extern void tracing_start(void);
extern void tracing_stop(void);
extern void ftrace_off_permanent(void);

static inline __attribute__((always_inline)) __attribute__((format(printf, =
1, 2)))
void ____trace_printk_check_format(const char *fmt, ...)
{
}
# 497 "include/linux/kernel.h"
extern __attribute__((format(printf, 2, 3)))
int __trace_bprintk(unsigned long ip, const char *fmt, ...);

extern __attribute__((format(printf, 2, 3)))
int __trace_printk(unsigned long ip, const char *fmt, ...);

extern void trace_dump_stack(void);
# 522 "include/linux/kernel.h"
extern int
__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);

extern int
__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);

extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
# 709 "include/linux/kernel.h"
extern int do_sysinfo(struct sysinfo *info);
# 16 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h" 2
# 1 "/home/shawn/source/linux/arch/arm/include/asm/unaligned.h" 1



# 1 "include/linux/unaligned/le_byteshift.h" 1





static inline __attribute__((always_inline)) u16 __get_unaligned_le16(const=
 u8 *p)
{
 return p[0] | p[1] << 8;
}

static inline __attribute__((always_inline)) u32 __get_unaligned_le32(const=
 u8 *p)
{
 return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
}

static inline __attribute__((always_inline)) u64 __get_unaligned_le64(const=
 u8 *p)
{
 return (u64)__get_unaligned_le32(p + 4) << 32 |
        __get_unaligned_le32(p);
}

static inline __attribute__((always_inline)) void __put_unaligned_le16(u16 =
val, u8 *p)
{
 *p++ =3D val;
 *p++ =3D val >> 8;
}

static inline __attribute__((always_inline)) void __put_unaligned_le32(u32 =
val, u8 *p)
{
 __put_unaligned_le16(val >> 16, p + 2);
 __put_unaligned_le16(val, p);
}

static inline __attribute__((always_inline)) void __put_unaligned_le64(u64 =
val, u8 *p)
{
 __put_unaligned_le32(val >> 32, p + 4);
 __put_unaligned_le32(val, p);
}

static inline __attribute__((always_inline)) u16 get_unaligned_le16(const v=
oid *p)
{
 return __get_unaligned_le16((const u8 *)p);
}

static inline __attribute__((always_inline)) u32 get_unaligned_le32(const v=
oid *p)
{
 return __get_unaligned_le32((const u8 *)p);
}

static inline __attribute__((always_inline)) u64 get_unaligned_le64(const v=
oid *p)
{
 return __get_unaligned_le64((const u8 *)p);
}

static inline __attribute__((always_inline)) void put_unaligned_le16(u16 va=
l, void *p)
{
 __put_unaligned_le16(val, p);
}

static inline __attribute__((always_inline)) void put_unaligned_le32(u32 va=
l, void *p)
{
 __put_unaligned_le32(val, p);
}

static inline __attribute__((always_inline)) void put_unaligned_le64(u64 va=
l, void *p)
{
 __put_unaligned_le64(val, p);
}
# 5 "/home/shawn/source/linux/arch/arm/include/asm/unaligned.h" 2
# 1 "include/linux/unaligned/be_byteshift.h" 1





static inline __attribute__((always_inline)) u16 __get_unaligned_be16(const=
 u8 *p)
{
 return p[0] << 8 | p[1];
}

static inline __attribute__((always_inline)) u32 __get_unaligned_be32(const=
 u8 *p)
{
 return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
}

static inline __attribute__((always_inline)) u64 __get_unaligned_be64(const=
 u8 *p)
{
 return (u64)__get_unaligned_be32(p) << 32 |
        __get_unaligned_be32(p + 4);
}

static inline __attribute__((always_inline)) void __put_unaligned_be16(u16 =
val, u8 *p)
{
 *p++ =3D val >> 8;
 *p++ =3D val;
}

static inline __attribute__((always_inline)) void __put_unaligned_be32(u32 =
val, u8 *p)
{
 __put_unaligned_be16(val >> 16, p);
 __put_unaligned_be16(val, p + 2);
}

static inline __attribute__((always_inline)) void __put_unaligned_be64(u64 =
val, u8 *p)
{
 __put_unaligned_be32(val >> 32, p);
 __put_unaligned_be32(val, p + 4);
}

static inline __attribute__((always_inline)) u16 get_unaligned_be16(const v=
oid *p)
{
 return __get_unaligned_be16((const u8 *)p);
}

static inline __attribute__((always_inline)) u32 get_unaligned_be32(const v=
oid *p)
{
 return __get_unaligned_be32((const u8 *)p);
}

static inline __attribute__((always_inline)) u64 get_unaligned_be64(const v=
oid *p)
{
 return __get_unaligned_be64((const u8 *)p);
}

static inline __attribute__((always_inline)) void put_unaligned_be16(u16 va=
l, void *p)
{
 __put_unaligned_be16(val, p);
}

static inline __attribute__((always_inline)) void put_unaligned_be32(u32 va=
l, void *p)
{
 __put_unaligned_be32(val, p);
}

static inline __attribute__((always_inline)) void put_unaligned_be64(u64 va=
l, void *p)
{
 __put_unaligned_be64(val, p);
}
# 6 "/home/shawn/source/linux/arch/arm/include/asm/unaligned.h" 2
# 1 "include/linux/unaligned/generic.h" 1







extern void __bad_unaligned_access_size(void);
# 7 "/home/shawn/source/linux/arch/arm/include/asm/unaligned.h" 2
# 17 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h" 2
# 109 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h"
static struct xz_dec_lzma2 *xz_dec_lzma2_create(enum xz_mode mode,
         uint32_t dict_max);







static enum xz_ret xz_dec_lzma2_reset(struct xz_dec_lzma2 *s,
      uint8_t props);


static enum xz_ret xz_dec_lzma2_run(struct xz_dec_lzma2 *s,
           struct xz_buf *b);


static void xz_dec_lzma2_end(struct xz_dec_lzma2 *s);






static struct xz_dec_bcj *xz_dec_bcj_create(bool single_call);







static enum xz_ret xz_dec_bcj_reset(struct xz_dec_bcj *s, uint8_t id);






static enum xz_ret xz_dec_bcj_run(struct xz_dec_bcj *s,
         struct xz_dec_lzma2 *lzma2,
         struct xz_buf *b);
# 146 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 2
# 177 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c"
static bool memeq(const void *a, const void *b, size_t size)
{
 const uint8_t *x =3D a;
 const uint8_t *y =3D b;
 size_t i;

 for (i =3D 0; i < size; ++i)
  if (x[i] !=3D y[i])
   return false;

 return true;
}



static void memzero(void *buf, size_t size)
{
 uint8_t *b =3D buf;
 uint8_t *e =3D b + size;

 while (b !=3D e)
  *b++ =3D '\0';
}
# 233 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c"
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_crc32.c" 1
# 18 "arch/arm/boot/compressed/../../../../lib/xz/xz_crc32.c"
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_private.h" 1
# 19 "arch/arm/boot/compressed/../../../../lib/xz/xz_crc32.c" 2
# 28 "arch/arm/boot/compressed/../../../../lib/xz/xz_crc32.c"
 uint32_t xz_crc32_table[256];

static void xz_crc32_init(void)
{
 const uint32_t poly =3D 0xEDB88320;

 uint32_t i;
 uint32_t j;
 uint32_t r;

 for (i =3D 0; i < 256; ++i) {
  r =3D i;
  for (j =3D 0; j < 8; ++j)
   r =3D (r >> 1) ^ (poly & ~((r & 1) - 1));

  xz_crc32_table[i] =3D r;
 }

 return;
}

static uint32_t xz_crc32(const uint8_t *buf, size_t size, uint32_t crc)
{
 crc =3D ~crc;

 while (size !=3D 0) {
  crc =3D xz_crc32_table[*buf++ ^ (crc & 0xFF)] ^ (crc >> 8);
  --size;
 }

 return ~crc;
}
# 234 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 2
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c" 1
# 11 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_stream.h" 1
# 43 "arch/arm/boot/compressed/../../../../lib/xz/xz_stream.h"
typedef uint64_t vli_type;
# 52 "arch/arm/boot/compressed/../../../../lib/xz/xz_stream.h"
enum xz_check {
 XZ_CHECK_NONE =3D 0,
 XZ_CHECK_CRC32 =3D 1,
 XZ_CHECK_CRC64 =3D 4,
 XZ_CHECK_SHA256 =3D 10
};
# 12 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c" 2


struct xz_dec_hash {
 vli_type unpadded;
 vli_type uncompressed;
 uint32_t crc32;
};

struct xz_dec {

 enum {
  SEQ_STREAM_HEADER,
  SEQ_BLOCK_START,
  SEQ_BLOCK_HEADER,
  SEQ_BLOCK_UNCOMPRESS,
  SEQ_BLOCK_PADDING,
  SEQ_BLOCK_CHECK,
  SEQ_INDEX,
  SEQ_INDEX_PADDING,
  SEQ_INDEX_CRC32,
  SEQ_STREAM_FOOTER
 } sequence;


 uint32_t pos;


 vli_type vli;


 size_t in_start;
 size_t out_start;


 uint32_t crc32;


 enum xz_check check_type;


 enum xz_mode mode;





 bool allow_buf_error;


 struct {




  vli_type compressed;





  vli_type uncompressed;


  uint32_t size;
 } block_header;


 struct {

  vli_type compressed;


  vli_type uncompressed;


  vli_type count;





  struct xz_dec_hash hash;
 } block;


 struct {

  enum {
   SEQ_INDEX_COUNT,
   SEQ_INDEX_UNPADDED,
   SEQ_INDEX_UNCOMPRESSED
  } sequence;


  vli_type size;


  vli_type count;





  struct xz_dec_hash hash;
 } index;
# 125 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
 struct {
  size_t pos;
  size_t size;
  uint8_t buf[1024];
 } temp;

 struct xz_dec_lzma2 *lzma2;


 struct xz_dec_bcj *bcj;
 bool bcj_active;

};
# 157 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
static bool fill_temp(struct xz_dec *s, struct xz_buf *b)
{
 size_t copy_size =3D ({ size_t __min1 =3D (b->in_size - b->in_pos); size_t=
 __min2 =3D (s->temp.size - s->temp.pos); __min1 < __min2 ? __min1: __min2;=
 })
                                                      ;

 memcpy(s->temp.buf + s->temp.pos, b->in + b->in_pos, copy_size);
 b->in_pos +=3D copy_size;
 s->temp.pos +=3D copy_size;

 if (s->temp.pos =3D=3D s->temp.size) {
  s->temp.pos =3D 0;
  return true;
 }

 return false;
}


static enum xz_ret dec_vli(struct xz_dec *s, const uint8_t *in,
      size_t *in_pos, size_t in_size)
{
 uint8_t byte;

 if (s->pos =3D=3D 0)
  s->vli =3D 0;

 while (*in_pos < in_size) {
  byte =3D in[*in_pos];
  ++*in_pos;

  s->vli |=3D (vli_type)(byte & 0x7F) << s->pos;

  if ((byte & 0x80) =3D=3D 0) {

   if (byte =3D=3D 0 && s->pos !=3D 0)
    return XZ_DATA_ERROR;

   s->pos =3D 0;
   return XZ_STREAM_END;
  }

  s->pos +=3D 7;
  if (s->pos =3D=3D 7 * (sizeof(vli_type) * 8 / 7))
   return XZ_DATA_ERROR;
 }

 return XZ_OK;
}
# 218 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
static enum xz_ret dec_block(struct xz_dec *s, struct xz_buf *b)
{
 enum xz_ret ret;

 s->in_start =3D b->in_pos;
 s->out_start =3D b->out_pos;


 if (s->bcj_active)
  ret =3D xz_dec_bcj_run(s->bcj, s->lzma2, b);
 else

  ret =3D xz_dec_lzma2_run(s->lzma2, b);

 s->block.compressed +=3D b->in_pos - s->in_start;
 s->block.uncompressed +=3D b->out_pos - s->out_start;





 if (s->block.compressed > s->block_header.compressed
   || s->block.uncompressed
    > s->block_header.uncompressed)
  return XZ_DATA_ERROR;

 if (s->check_type =3D=3D XZ_CHECK_CRC32)
  s->crc32 =3D xz_crc32(b->out + s->out_start,
    b->out_pos - s->out_start, s->crc32);

 if (ret =3D=3D XZ_STREAM_END) {
  if (s->block_header.compressed !=3D ((vli_type)-1)
    && s->block_header.compressed
     !=3D s->block.compressed)
   return XZ_DATA_ERROR;

  if (s->block_header.uncompressed !=3D ((vli_type)-1)
    && s->block_header.uncompressed
     !=3D s->block.uncompressed)
   return XZ_DATA_ERROR;

  s->block.hash.unpadded +=3D s->block_header.size
    + s->block.compressed;




  if (s->check_type =3D=3D XZ_CHECK_CRC32)
   s->block.hash.unpadded +=3D 4;


  s->block.hash.uncompressed +=3D s->block.uncompressed;
  s->block.hash.crc32 =3D xz_crc32(
    (const uint8_t *)&s->block.hash,
    sizeof(s->block.hash), s->block.hash.crc32);

  ++s->block.count;
 }

 return ret;
}


static void index_update(struct xz_dec *s, const struct xz_buf *b)
{
 size_t in_used =3D b->in_pos - s->in_start;
 s->index.size +=3D in_used;
 s->crc32 =3D xz_crc32(b->in + s->in_start, in_used, s->crc32);
}
# 296 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
static enum xz_ret dec_index(struct xz_dec *s, struct xz_buf *b)
{
 enum xz_ret ret;

 do {
  ret =3D dec_vli(s, b->in, &b->in_pos, b->in_size);
  if (ret !=3D XZ_STREAM_END) {
   index_update(s, b);
   return ret;
  }

  switch (s->index.sequence) {
  case SEQ_INDEX_COUNT:
   s->index.count =3D s->vli;






   if (s->index.count !=3D s->block.count)
    return XZ_DATA_ERROR;

   s->index.sequence =3D SEQ_INDEX_UNPADDED;
   break;

  case SEQ_INDEX_UNPADDED:
   s->index.hash.unpadded +=3D s->vli;
   s->index.sequence =3D SEQ_INDEX_UNCOMPRESSED;
   break;

  case SEQ_INDEX_UNCOMPRESSED:
   s->index.hash.uncompressed +=3D s->vli;
   s->index.hash.crc32 =3D xz_crc32(
     (const uint8_t *)&s->index.hash,
     sizeof(s->index.hash),
     s->index.hash.crc32);
   --s->index.count;
   s->index.sequence =3D SEQ_INDEX_UNPADDED;
   break;
  }
 } while (s->index.count > 0);

 return XZ_STREAM_END;
}





static enum xz_ret crc32_validate(struct xz_dec *s, struct xz_buf *b)
{
 do {
  if (b->in_pos =3D=3D b->in_size)
   return XZ_OK;

  if (((s->crc32 >> s->pos) & 0xFF) !=3D b->in[b->in_pos++])
   return XZ_DATA_ERROR;

  s->pos +=3D 8;

 } while (s->pos < 32);

 s->crc32 =3D 0;
 s->pos =3D 0;

 return XZ_STREAM_END;
}
# 387 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
static enum xz_ret dec_stream_header(struct xz_dec *s)
{
 if (!memeq(s->temp.buf, "\3757zXZ", 6))
  return XZ_FORMAT_ERROR;

 if (xz_crc32(s->temp.buf + 6, 2, 0)
   !=3D __le32_to_cpup((const uint32_t *)(s->temp.buf + 6 + 2)))
  return XZ_DATA_ERROR;

 if (s->temp.buf[6] !=3D 0)
  return XZ_OPTIONS_ERROR;







 s->check_type =3D s->temp.buf[6 + 1];
# 414 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
 if (s->check_type > XZ_CHECK_CRC32)
  return XZ_OPTIONS_ERROR;


 return XZ_OK;
}


static enum xz_ret dec_stream_footer(struct xz_dec *s)
{
 if (!memeq(s->temp.buf + 10, "YZ", 2))
  return XZ_DATA_ERROR;

 if (xz_crc32(s->temp.buf + 4, 6, 0) !=3D __le32_to_cpup((const uint32_t *)=
(s->temp.buf)))
  return XZ_DATA_ERROR;






 if ((s->index.size >> 2) !=3D __le32_to_cpup((const uint32_t *)(s->temp.bu=
f + 4)))
  return XZ_DATA_ERROR;

 if (s->temp.buf[8] !=3D 0 || s->temp.buf[9] !=3D s->check_type)
  return XZ_DATA_ERROR;





 return XZ_STREAM_END;
}


static enum xz_ret dec_block_header(struct xz_dec *s)
{
 enum xz_ret ret;





 s->temp.size -=3D 4;
 if (xz_crc32(s->temp.buf, s->temp.size, 0)
   !=3D __le32_to_cpup((const uint32_t *)(s->temp.buf + s->temp.size)))
  return XZ_DATA_ERROR;

 s->temp.pos =3D 2;






 if (s->temp.buf[1] & 0x3E)



  return XZ_OPTIONS_ERROR;


 if (s->temp.buf[1] & 0x40) {
  if (dec_vli(s, s->temp.buf, &s->temp.pos, s->temp.size)
     !=3D XZ_STREAM_END)
   return XZ_DATA_ERROR;

  s->block_header.compressed =3D s->vli;
 } else {
  s->block_header.compressed =3D ((vli_type)-1);
 }


 if (s->temp.buf[1] & 0x80) {
  if (dec_vli(s, s->temp.buf, &s->temp.pos, s->temp.size)
    !=3D XZ_STREAM_END)
   return XZ_DATA_ERROR;

  s->block_header.uncompressed =3D s->vli;
 } else {
  s->block_header.uncompressed =3D ((vli_type)-1);
 }



 s->bcj_active =3D s->temp.buf[1] & 0x01;
 if (s->bcj_active) {
  if (s->temp.size - s->temp.pos < 2)
   return XZ_OPTIONS_ERROR;

  ret =3D xz_dec_bcj_reset(s->bcj, s->temp.buf[s->temp.pos++]);
  if (ret !=3D XZ_OK)
   return ret;





  if (s->temp.buf[s->temp.pos++] !=3D 0x00)
   return XZ_OPTIONS_ERROR;
 }



 if (s->temp.size - s->temp.pos < 2)
  return XZ_DATA_ERROR;


 if (s->temp.buf[s->temp.pos++] !=3D 0x21)
  return XZ_OPTIONS_ERROR;


 if (s->temp.buf[s->temp.pos++] !=3D 0x01)
  return XZ_OPTIONS_ERROR;


 if (s->temp.size - s->temp.pos < 1)
  return XZ_DATA_ERROR;

 ret =3D xz_dec_lzma2_reset(s->lzma2, s->temp.buf[s->temp.pos++]);
 if (ret !=3D XZ_OK)
  return ret;


 while (s->temp.pos < s->temp.size)
  if (s->temp.buf[s->temp.pos++] !=3D 0x00)
   return XZ_OPTIONS_ERROR;

 s->temp.pos =3D 0;
 s->block.compressed =3D 0;
 s->block.uncompressed =3D 0;

 return XZ_OK;
}

static enum xz_ret dec_main(struct xz_dec *s, struct xz_buf *b)
{
 enum xz_ret ret;





 s->in_start =3D b->in_pos;

 while (true) {
  switch (s->sequence) {
  case SEQ_STREAM_HEADER:
# 570 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
   if (!fill_temp(s, b))
    return XZ_OK;
# 580 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
   s->sequence =3D SEQ_BLOCK_START;

   ret =3D dec_stream_header(s);
   if (ret !=3D XZ_OK)
    return ret;

  case SEQ_BLOCK_START:

   if (b->in_pos =3D=3D b->in_size)
    return XZ_OK;


   if (b->in[b->in_pos] =3D=3D 0) {
    s->in_start =3D b->in_pos++;
    s->sequence =3D SEQ_INDEX;
    break;
   }





   s->block_header.size
    =3D ((uint32_t)b->in[b->in_pos] + 1) * 4;

   s->temp.size =3D s->block_header.size;
   s->temp.pos =3D 0;
   s->sequence =3D SEQ_BLOCK_HEADER;

  case SEQ_BLOCK_HEADER:
   if (!fill_temp(s, b))
    return XZ_OK;

   ret =3D dec_block_header(s);
   if (ret !=3D XZ_OK)
    return ret;

   s->sequence =3D SEQ_BLOCK_UNCOMPRESS;

  case SEQ_BLOCK_UNCOMPRESS:
   ret =3D dec_block(s, b);
   if (ret !=3D XZ_STREAM_END)
    return ret;

   s->sequence =3D SEQ_BLOCK_PADDING;

  case SEQ_BLOCK_PADDING:







   while (s->block.compressed & 3) {
    if (b->in_pos =3D=3D b->in_size)
     return XZ_OK;

    if (b->in[b->in_pos++] !=3D 0)
     return XZ_DATA_ERROR;

    ++s->block.compressed;
   }

   s->sequence =3D SEQ_BLOCK_CHECK;

  case SEQ_BLOCK_CHECK:
   if (s->check_type =3D=3D XZ_CHECK_CRC32) {
    ret =3D crc32_validate(s, b);
    if (ret !=3D XZ_STREAM_END)
     return ret;
   }






   s->sequence =3D SEQ_BLOCK_START;
   break;

  case SEQ_INDEX:
   ret =3D dec_index(s, b);
   if (ret !=3D XZ_STREAM_END)
    return ret;

   s->sequence =3D SEQ_INDEX_PADDING;

  case SEQ_INDEX_PADDING:
   while ((s->index.size + (b->in_pos - s->in_start))
     & 3) {
    if (b->in_pos =3D=3D b->in_size) {
     index_update(s, b);
     return XZ_OK;
    }

    if (b->in[b->in_pos++] !=3D 0)
     return XZ_DATA_ERROR;
   }


   index_update(s, b);


   if (!memeq(&s->block.hash, &s->index.hash,
     sizeof(s->block.hash)))
    return XZ_DATA_ERROR;

   s->sequence =3D SEQ_INDEX_CRC32;

  case SEQ_INDEX_CRC32:
   ret =3D crc32_validate(s, b);
   if (ret !=3D XZ_STREAM_END)
    return ret;

   s->temp.size =3D 12;
   s->sequence =3D SEQ_STREAM_FOOTER;

  case SEQ_STREAM_FOOTER:
   if (!fill_temp(s, b))
    return XZ_OK;

   return dec_stream_footer(s);
  }
 }


}
# 734 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c"
static enum xz_ret xz_dec_run(struct xz_dec *s, struct xz_buf *b)
{
 size_t in_start;
 size_t out_start;
 enum xz_ret ret;

 if (((s->mode) =3D=3D XZ_SINGLE))
  xz_dec_reset(s);

 in_start =3D b->in_pos;
 out_start =3D b->out_pos;
 ret =3D dec_main(s, b);

 if (((s->mode) =3D=3D XZ_SINGLE)) {
  if (ret =3D=3D XZ_OK)
   ret =3D b->in_pos =3D=3D b->in_size
     ? XZ_DATA_ERROR : XZ_BUF_ERROR;

  if (ret !=3D XZ_STREAM_END) {
   b->in_pos =3D in_start;
   b->out_pos =3D out_start;
  }

 } else if (ret =3D=3D XZ_OK && in_start =3D=3D b->in_pos
   && out_start =3D=3D b->out_pos) {
  if (s->allow_buf_error)
   ret =3D XZ_BUF_ERROR;

  s->allow_buf_error =3D true;
 } else {
  s->allow_buf_error =3D false;
 }

 return ret;
}

static struct xz_dec *xz_dec_init(enum xz_mode mode, uint32_t dict_max)
{
 struct xz_dec *s =3D malloc(sizeof(*s));
 if (s =3D=3D ((void *)0))
  return ((void *)0);

 s->mode =3D mode;


 s->bcj =3D xz_dec_bcj_create(((mode) =3D=3D XZ_SINGLE));
 if (s->bcj =3D=3D ((void *)0))
  goto error_bcj;


 s->lzma2 =3D xz_dec_lzma2_create(mode, dict_max);
 if (s->lzma2 =3D=3D ((void *)0))
  goto error_lzma2;

 xz_dec_reset(s);
 return s;

error_lzma2:

 free(s->bcj);
error_bcj:

 free(s);
 return ((void *)0);
}

static void xz_dec_reset(struct xz_dec *s)
{
 s->sequence =3D SEQ_STREAM_HEADER;
 s->allow_buf_error =3D false;
 s->pos =3D 0;
 s->crc32 =3D 0;
 memzero(&s->block, sizeof(s->block));
 memzero(&s->index, sizeof(s->index));
 s->temp.pos =3D 0;
 s->temp.size =3D 12;
}

static void xz_dec_end(struct xz_dec *s)
{
 if (s !=3D ((void *)0)) {
  xz_dec_lzma2_end(s->lzma2);

  free(s->bcj);

  free(s);
 }
}
# 235 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 2
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c" 1
# 12 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_lzma2.h" 1
# 42 "arch/arm/boot/compressed/../../../../lib/xz/xz_lzma2.h"
enum lzma_state {
 STATE_LIT_LIT,
 STATE_MATCH_LIT_LIT,
 STATE_REP_LIT_LIT,
 STATE_SHORTREP_LIT_LIT,
 STATE_MATCH_LIT,
 STATE_REP_LIT,
 STATE_SHORTREP_LIT,
 STATE_LIT_MATCH,
 STATE_LIT_LONGREP,
 STATE_LIT_SHORTREP,
 STATE_NONLIT_MATCH,
 STATE_NONLIT_REP
};
# 64 "arch/arm/boot/compressed/../../../../lib/xz/xz_lzma2.h"
static inline __attribute__((always_inline)) void lzma_state_literal(enum l=
zma_state *state)
{
 if (*state <=3D STATE_SHORTREP_LIT_LIT)
  *state =3D STATE_LIT_LIT;
 else if (*state <=3D STATE_LIT_SHORTREP)
  *state -=3D 3;
 else
  *state -=3D 6;
}


static inline __attribute__((always_inline)) void lzma_state_match(enum lzm=
a_state *state)
{
 *state =3D *state < 7 ? STATE_LIT_MATCH : STATE_NONLIT_MATCH;
}


static inline __attribute__((always_inline)) void lzma_state_long_rep(enum =
lzma_state *state)
{
 *state =3D *state < 7 ? STATE_LIT_LONGREP : STATE_NONLIT_REP;
}


static inline __attribute__((always_inline)) void lzma_state_short_rep(enum=
 lzma_state *state)
{
 *state =3D *state < 7 ? STATE_LIT_SHORTREP : STATE_NONLIT_REP;
}


static inline __attribute__((always_inline)) bool lzma_state_is_literal(enu=
m lzma_state state)
{
 return state < 7;
}
# 147 "arch/arm/boot/compressed/../../../../lib/xz/xz_lzma2.h"
static inline __attribute__((always_inline)) uint32_t lzma_get_dist_state(u=
int32_t len)
{
 return len < 4 + 2
   ? len - 2 : 4 - 1;
}
# 13 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c" 2
# 44 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
struct dictionary {

 uint8_t *buf;


 size_t start;


 size_t pos;





 size_t full;


 size_t limit;






 size_t end;






 uint32_t size;





 uint32_t size_max;






 uint32_t allocated;


 enum xz_mode mode;
};


struct rc_dec {
 uint32_t range;
 uint32_t code;





 uint32_t init_bytes_left;





 const uint8_t *in;
 size_t in_pos;
 size_t in_limit;
};


struct lzma_len_dec {

 uint16_t choice;


 uint16_t choice2;


 uint16_t low[(1 << 4)][(1 << 3)];


 uint16_t mid[(1 << 4)][(1 << 3)];


 uint16_t high[(1 << 8)];
};

struct lzma_dec {

 uint32_t rep0;
 uint32_t rep1;
 uint32_t rep2;
 uint32_t rep3;


 enum lzma_state state;





 uint32_t len;







 uint32_t lc;
 uint32_t literal_pos_mask;
 uint32_t pos_mask;


 uint16_t is_match[12][(1 << 4)];


 uint16_t is_rep[12];





 uint16_t is_rep0[12];





 uint16_t is_rep1[12];


 uint16_t is_rep2[12];





 uint16_t is_rep0_long[12][(1 << 4)];






 uint16_t dist_slot[4][(1 << 6)];





 uint16_t dist_special[(1 << (14 / 2)) - 14];





 uint16_t dist_align[(1 << 4)];


 struct lzma_len_dec match_len_dec;


 struct lzma_len_dec rep_len_dec;


 uint16_t literal[(1 << 4)][0x300];
};

struct lzma2_dec {

 enum lzma2_seq {
  SEQ_CONTROL,
  SEQ_UNCOMPRESSED_1,
  SEQ_UNCOMPRESSED_2,
  SEQ_COMPRESSED_0,
  SEQ_COMPRESSED_1,
  SEQ_PROPERTIES,
  SEQ_LZMA_PREPARE,
  SEQ_LZMA_RUN,
  SEQ_COPY
 } sequence;


 enum lzma2_seq next_sequence;


 uint32_t uncompressed;





 uint32_t compressed;





 bool need_dict_reset;





 bool need_props;
};

struct xz_dec_lzma2 {
# 263 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
 struct rc_dec rc;
 struct dictionary dict;
 struct lzma2_dec lzma2;
 struct lzma_dec lzma;





 struct {
  uint32_t size;
  uint8_t buf[3 * 21];
 } temp;
};
# 286 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
static void dict_reset(struct dictionary *dict, struct xz_buf *b)
{
 if (((dict->mode) =3D=3D XZ_SINGLE)) {
  dict->buf =3D b->out + b->out_pos;
  dict->end =3D b->out_size - b->out_pos;
 }

 dict->start =3D 0;
 dict->pos =3D 0;
 dict->limit =3D 0;
 dict->full =3D 0;
}


static void dict_limit(struct dictionary *dict, size_t out_max)
{
 if (dict->end - dict->pos <=3D out_max)
  dict->limit =3D dict->end;
 else
  dict->limit =3D dict->pos + out_max;
}


static inline __attribute__((always_inline)) bool dict_has_space(const stru=
ct dictionary *dict)
{
 return dict->pos < dict->limit;
}







static inline __attribute__((always_inline)) uint32_t dict_get(const struct=
 dictionary *dict, uint32_t dist)
{
 size_t offset =3D dict->pos - dist - 1;

 if (dist >=3D dict->pos)
  offset +=3D dict->end;

 return dict->full > 0 ? dict->buf[offset] : 0;
}




static inline __attribute__((always_inline)) void dict_put(struct dictionar=
y *dict, uint8_t byte)
{
 dict->buf[dict->pos++] =3D byte;

 if (dict->full < dict->pos)
  dict->full =3D dict->pos;
}






static bool dict_repeat(struct dictionary *dict, uint32_t *len, uint32_t di=
st)
{
 size_t back;
 uint32_t left;

 if (dist >=3D dict->full || dist >=3D dict->size)
  return false;

 left =3D ({ size_t __min1 =3D (dict->limit - dict->pos); size_t __min2 =3D=
 (*len); __min1 < __min2 ? __min1: __min2; });
 *len -=3D left;

 back =3D dict->pos - dist - 1;
 if (dist >=3D dict->pos)
  back +=3D dict->end;

 do {
  dict->buf[dict->pos++] =3D dict->buf[back++];
  if (back =3D=3D dict->end)
   back =3D 0;
 } while (--left > 0);

 if (dict->full < dict->pos)
  dict->full =3D dict->pos;

 return true;
}


static void dict_uncompressed(struct dictionary *dict, struct xz_buf *b,
         uint32_t *left)
{
 size_t copy_size;

 while (*left > 0 && b->in_pos < b->in_size
   && b->out_pos < b->out_size) {
  copy_size =3D ({ typeof(b->in_size - b->in_pos) _min1 =3D (b->in_size - b=
->in_pos); typeof(b->out_size - b->out_pos) _min2 =3D (b->out_size - b->out=
_pos); (void) (&_min1 =3D=3D &_min2); _min1 < _min2 ? _min1 : _min2; })
                             ;
  if (copy_size > dict->end - dict->pos)
   copy_size =3D dict->end - dict->pos;
  if (copy_size > *left)
   copy_size =3D *left;

  *left -=3D copy_size;

  memcpy(dict->buf + dict->pos, b->in + b->in_pos, copy_size);
  dict->pos +=3D copy_size;

  if (dict->full < dict->pos)
   dict->full =3D dict->pos;

  if (((dict->mode) !=3D XZ_SINGLE)) {
   if (dict->pos =3D=3D dict->end)
    dict->pos =3D 0;

   memcpy(b->out + b->out_pos, b->in + b->in_pos,
     copy_size);
  }

  dict->start =3D dict->pos;

  b->out_pos +=3D copy_size;
  b->in_pos +=3D copy_size;
 }
}






static uint32_t dict_flush(struct dictionary *dict, struct xz_buf *b)
{
 size_t copy_size =3D dict->pos - dict->start;

 if (((dict->mode) !=3D XZ_SINGLE)) {
  if (dict->pos =3D=3D dict->end)
   dict->pos =3D 0;

  memcpy(b->out + b->out_pos, dict->buf + dict->start,
    copy_size);
 }

 dict->start =3D dict->pos;
 b->out_pos +=3D copy_size;
 return copy_size;
}






static void rc_reset(struct rc_dec *rc)
{
 rc->range =3D (uint32_t)-1;
 rc->code =3D 0;
 rc->init_bytes_left =3D 5;
}





static bool rc_read_init(struct rc_dec *rc, struct xz_buf *b)
{
 while (rc->init_bytes_left > 0) {
  if (b->in_pos =3D=3D b->in_size)
   return false;

  rc->code =3D (rc->code << 8) + b->in[b->in_pos++];
  --rc->init_bytes_left;
 }

 return true;
}


static inline __attribute__((always_inline)) bool rc_limit_exceeded(const s=
truct rc_dec *rc)
{
 return rc->in_pos > rc->in_limit;
}





static inline __attribute__((always_inline)) bool rc_is_finished(const stru=
ct rc_dec *rc)
{
 return rc->code =3D=3D 0;
}


static inline __attribute__((always_inline)) __attribute__((always_inline))=
 void rc_normalize(struct rc_dec *rc)
{
 if (rc->range < (1 << 24)) {
  rc->range <<=3D 8;
  rc->code =3D (rc->code << 8) + rc->in[rc->in_pos++];
 }
}
# 497 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
static inline __attribute__((always_inline)) __attribute__((always_inline))=
 int rc_bit(struct rc_dec *rc, uint16_t *prob)
{
 uint32_t bound;
 int bit;

 rc_normalize(rc);
 bound =3D (rc->range >> 11) * *prob;
 if (rc->code < bound) {
  rc->range =3D bound;
  *prob +=3D ((1 << 11) - *prob) >> 5;
  bit =3D 0;
 } else {
  rc->range -=3D bound;
  rc->code -=3D bound;
  *prob -=3D *prob >> 5;
  bit =3D 1;
 }

 return bit;
}


static inline __attribute__((always_inline)) __attribute__((always_inline))=
 uint32_t rc_bittree(struct rc_dec *rc,
        uint16_t *probs, uint32_t limit)
{
 uint32_t symbol =3D 1;

 do {
  if (rc_bit(rc, &probs[symbol]))
   symbol =3D (symbol << 1) + 1;
  else
   symbol <<=3D 1;
 } while (symbol < limit);

 return symbol;
}


static inline __attribute__((always_inline)) __attribute__((always_inline))=
 void rc_bittree_reverse(struct rc_dec *rc,
            uint16_t *probs,
            uint32_t *dest, uint32_t limit)
{
 uint32_t symbol =3D 1;
 uint32_t i =3D 0;

 do {
  if (rc_bit(rc, &probs[symbol])) {
   symbol =3D (symbol << 1) + 1;
   *dest +=3D 1 << i;
  } else {
   symbol <<=3D 1;
  }
 } while (++i < limit);
}


static inline __attribute__((always_inline)) void rc_direct(struct rc_dec *=
rc, uint32_t *dest, uint32_t limit)
{
 uint32_t mask;

 do {
  rc_normalize(rc);
  rc->range >>=3D 1;
  rc->code -=3D rc->range;
  mask =3D (uint32_t)0 - (rc->code >> 31);
  rc->code +=3D rc->range & mask;
  *dest =3D (*dest << 1) + (mask + 1);
 } while (--limit > 0);
}






static uint16_t *lzma_literal_probs(struct xz_dec_lzma2 *s)
{
 uint32_t prev_byte =3D dict_get(&s->dict, 0);
 uint32_t low =3D prev_byte >> (8 - s->lzma.lc);
 uint32_t high =3D (s->dict.pos & s->lzma.literal_pos_mask) << s->lzma.lc;
 return s->lzma.literal[low + high];
}


static void lzma_literal(struct xz_dec_lzma2 *s)
{
 uint16_t *probs;
 uint32_t symbol;
 uint32_t match_byte;
 uint32_t match_bit;
 uint32_t offset;
 uint32_t i;

 probs =3D lzma_literal_probs(s);

 if (lzma_state_is_literal(s->lzma.state)) {
  symbol =3D rc_bittree(&s->rc, probs, 0x100);
 } else {
  symbol =3D 1;
  match_byte =3D dict_get(&s->dict, s->lzma.rep0) << 1;
  offset =3D 0x100;

  do {
   match_bit =3D match_byte & offset;
   match_byte <<=3D 1;
   i =3D offset + match_bit + symbol;

   if (rc_bit(&s->rc, &probs[i])) {
    symbol =3D (symbol << 1) + 1;
    offset &=3D match_bit;
   } else {
    symbol <<=3D 1;
    offset &=3D ~match_bit;
   }
  } while (symbol < 0x100);
 }

 dict_put(&s->dict, (uint8_t)symbol);
 lzma_state_literal(&s->lzma.state);
}


static void lzma_len(struct xz_dec_lzma2 *s, struct lzma_len_dec *l,
       uint32_t pos_state)
{
 uint16_t *probs;
 uint32_t limit;

 if (!rc_bit(&s->rc, &l->choice)) {
  probs =3D l->low[pos_state];
  limit =3D (1 << 3);
  s->lzma.len =3D 2;
 } else {
  if (!rc_bit(&s->rc, &l->choice2)) {
   probs =3D l->mid[pos_state];
   limit =3D (1 << 3);
   s->lzma.len =3D 2 + (1 << 3);
  } else {
   probs =3D l->high;
   limit =3D (1 << 8);
   s->lzma.len =3D 2 + (1 << 3)
     + (1 << 3);
  }
 }

 s->lzma.len +=3D rc_bittree(&s->rc, probs, limit) - limit;
}


static void lzma_match(struct xz_dec_lzma2 *s, uint32_t pos_state)
{
 uint16_t *probs;
 uint32_t dist_slot;
 uint32_t limit;

 lzma_state_match(&s->lzma.state);

 s->lzma.rep3 =3D s->lzma.rep2;
 s->lzma.rep2 =3D s->lzma.rep1;
 s->lzma.rep1 =3D s->lzma.rep0;

 lzma_len(s, &s->lzma.match_len_dec, pos_state);

 probs =3D s->lzma.dist_slot[lzma_get_dist_state(s->lzma.len)];
 dist_slot =3D rc_bittree(&s->rc, probs, (1 << 6)) - (1 << 6);

 if (dist_slot < 4) {
  s->lzma.rep0 =3D dist_slot;
 } else {
  limit =3D (dist_slot >> 1) - 1;
  s->lzma.rep0 =3D 2 + (dist_slot & 1);

  if (dist_slot < 14) {
   s->lzma.rep0 <<=3D limit;
   probs =3D s->lzma.dist_special + s->lzma.rep0
     - dist_slot - 1;
   rc_bittree_reverse(&s->rc, probs,
     &s->lzma.rep0, limit);
  } else {
   rc_direct(&s->rc, &s->lzma.rep0, limit - 4);
   s->lzma.rep0 <<=3D 4;
   rc_bittree_reverse(&s->rc, s->lzma.dist_align,
     &s->lzma.rep0, 4);
  }
 }
}





static void lzma_rep_match(struct xz_dec_lzma2 *s, uint32_t pos_state)
{
 uint32_t tmp;

 if (!rc_bit(&s->rc, &s->lzma.is_rep0[s->lzma.state])) {
  if (!rc_bit(&s->rc, &s->lzma.is_rep0_long[
    s->lzma.state][pos_state])) {
   lzma_state_short_rep(&s->lzma.state);
   s->lzma.len =3D 1;
   return;
  }
 } else {
  if (!rc_bit(&s->rc, &s->lzma.is_rep1[s->lzma.state])) {
   tmp =3D s->lzma.rep1;
  } else {
   if (!rc_bit(&s->rc, &s->lzma.is_rep2[s->lzma.state])) {
    tmp =3D s->lzma.rep2;
   } else {
    tmp =3D s->lzma.rep3;
    s->lzma.rep3 =3D s->lzma.rep2;
   }

   s->lzma.rep2 =3D s->lzma.rep1;
  }

  s->lzma.rep1 =3D s->lzma.rep0;
  s->lzma.rep0 =3D tmp;
 }

 lzma_state_long_rep(&s->lzma.state);
 lzma_len(s, &s->lzma.rep_len_dec, pos_state);
}


static bool lzma_main(struct xz_dec_lzma2 *s)
{
 uint32_t pos_state;





 if (dict_has_space(&s->dict) && s->lzma.len > 0)
  dict_repeat(&s->dict, &s->lzma.len, s->lzma.rep0);





 while (dict_has_space(&s->dict) && !rc_limit_exceeded(&s->rc)) {
  pos_state =3D s->dict.pos & s->lzma.pos_mask;

  if (!rc_bit(&s->rc, &s->lzma.is_match[
    s->lzma.state][pos_state])) {
   lzma_literal(s);
  } else {
   if (rc_bit(&s->rc, &s->lzma.is_rep[s->lzma.state]))
    lzma_rep_match(s, pos_state);
   else
    lzma_match(s, pos_state);

   if (!dict_repeat(&s->dict, &s->lzma.len, s->lzma.rep0))
    return false;
  }
 }





 rc_normalize(&s->rc);

 return true;
}





static void lzma_reset(struct xz_dec_lzma2 *s)
{
 uint16_t *probs;
 size_t i;

 s->lzma.state =3D STATE_LIT_LIT;
 s->lzma.rep0 =3D 0;
 s->lzma.rep1 =3D 0;
 s->lzma.rep2 =3D 0;
 s->lzma.rep3 =3D 0;
# 787 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
 probs =3D s->lzma.is_match[0];
 for (i =3D 0; i < (1846 + (1 << 4) * 0x300); ++i)
  probs[i] =3D (1 << 11) / 2;

 rc_reset(&s->rc);
}






static bool lzma_props(struct xz_dec_lzma2 *s, uint8_t props)
{
 if (props > (4 * 5 + 4) * 9 + 8)
  return false;

 s->lzma.pos_mask =3D 0;
 while (props >=3D 9 * 5) {
  props -=3D 9 * 5;
  ++s->lzma.pos_mask;
 }

 s->lzma.pos_mask =3D (1 << s->lzma.pos_mask) - 1;

 s->lzma.literal_pos_mask =3D 0;
 while (props >=3D 9) {
  props -=3D 9;
  ++s->lzma.literal_pos_mask;
 }

 s->lzma.lc =3D props;

 if (s->lzma.lc + s->lzma.literal_pos_mask > 4)
  return false;

 s->lzma.literal_pos_mask =3D (1 << s->lzma.literal_pos_mask) - 1;

 lzma_reset(s);

 return true;
}
# 846 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
static bool lzma2_lzma(struct xz_dec_lzma2 *s, struct xz_buf *b)
{
 size_t in_avail;
 uint32_t tmp;

 in_avail =3D b->in_size - b->in_pos;
 if (s->temp.size > 0 || s->lzma2.compressed =3D=3D 0) {
  tmp =3D 2 * 21 - s->temp.size;
  if (tmp > s->lzma2.compressed - s->temp.size)
   tmp =3D s->lzma2.compressed - s->temp.size;
  if (tmp > in_avail)
   tmp =3D in_avail;

  memcpy(s->temp.buf + s->temp.size, b->in + b->in_pos, tmp);

  if (s->temp.size + tmp =3D=3D s->lzma2.compressed) {
   memzero(s->temp.buf + s->temp.size + tmp,
     sizeof(s->temp.buf)
      - s->temp.size - tmp);
   s->rc.in_limit =3D s->temp.size + tmp;
  } else if (s->temp.size + tmp < 21) {
   s->temp.size +=3D tmp;
   b->in_pos +=3D tmp;
   return true;
  } else {
   s->rc.in_limit =3D s->temp.size + tmp - 21;
  }

  s->rc.in =3D s->temp.buf;
  s->rc.in_pos =3D 0;

  if (!lzma_main(s) || s->rc.in_pos > s->temp.size + tmp)
   return false;

  s->lzma2.compressed -=3D s->rc.in_pos;

  if (s->rc.in_pos < s->temp.size) {
   s->temp.size -=3D s->rc.in_pos;
   memmove(s->temp.buf, s->temp.buf + s->rc.in_pos,
     s->temp.size);
   return true;
  }

  b->in_pos +=3D s->rc.in_pos - s->temp.size;
  s->temp.size =3D 0;
 }

 in_avail =3D b->in_size - b->in_pos;
 if (in_avail >=3D 21) {
  s->rc.in =3D b->in;
  s->rc.in_pos =3D b->in_pos;

  if (in_avail >=3D s->lzma2.compressed + 21)
   s->rc.in_limit =3D b->in_pos + s->lzma2.compressed;
  else
   s->rc.in_limit =3D b->in_size - 21;

  if (!lzma_main(s))
   return false;

  in_avail =3D s->rc.in_pos - b->in_pos;
  if (in_avail > s->lzma2.compressed)
   return false;

  s->lzma2.compressed -=3D in_avail;
  b->in_pos =3D s->rc.in_pos;
 }

 in_avail =3D b->in_size - b->in_pos;
 if (in_avail < 21) {
  if (in_avail > s->lzma2.compressed)
   in_avail =3D s->lzma2.compressed;

  memcpy(s->temp.buf, b->in + b->in_pos, in_avail);
  s->temp.size =3D in_avail;
  b->in_pos +=3D in_avail;
 }

 return true;
}





static enum xz_ret xz_dec_lzma2_run(struct xz_dec_lzma2 *s,
           struct xz_buf *b)
{
 uint32_t tmp;

 while (b->in_pos < b->in_size || s->lzma2.sequence =3D=3D SEQ_LZMA_RUN) {
  switch (s->lzma2.sequence) {
  case SEQ_CONTROL:
# 970 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
   tmp =3D b->in[b->in_pos++];

   if (tmp =3D=3D 0x00)
    return XZ_STREAM_END;

   if (tmp >=3D 0xE0 || tmp =3D=3D 0x01) {
    s->lzma2.need_props =3D true;
    s->lzma2.need_dict_reset =3D false;
    dict_reset(&s->dict, b);
   } else if (s->lzma2.need_dict_reset) {
    return XZ_DATA_ERROR;
   }

   if (tmp >=3D 0x80) {
    s->lzma2.uncompressed =3D (tmp & 0x1F) << 16;
    s->lzma2.sequence =3D SEQ_UNCOMPRESSED_1;

    if (tmp >=3D 0xC0) {





     s->lzma2.need_props =3D false;
     s->lzma2.next_sequence
       =3D SEQ_PROPERTIES;

    } else if (s->lzma2.need_props) {
     return XZ_DATA_ERROR;

    } else {
     s->lzma2.next_sequence
       =3D SEQ_LZMA_PREPARE;
     if (tmp >=3D 0xA0)
      lzma_reset(s);
    }
   } else {
    if (tmp > 0x02)
     return XZ_DATA_ERROR;

    s->lzma2.sequence =3D SEQ_COMPRESSED_0;
    s->lzma2.next_sequence =3D SEQ_COPY;
   }

   break;

  case SEQ_UNCOMPRESSED_1:
   s->lzma2.uncompressed
     +=3D (uint32_t)b->in[b->in_pos++] << 8;
   s->lzma2.sequence =3D SEQ_UNCOMPRESSED_2;
   break;

  case SEQ_UNCOMPRESSED_2:
   s->lzma2.uncompressed
     +=3D (uint32_t)b->in[b->in_pos++] + 1;
   s->lzma2.sequence =3D SEQ_COMPRESSED_0;
   break;

  case SEQ_COMPRESSED_0:
   s->lzma2.compressed
     =3D (uint32_t)b->in[b->in_pos++] << 8;
   s->lzma2.sequence =3D SEQ_COMPRESSED_1;
   break;

  case SEQ_COMPRESSED_1:
   s->lzma2.compressed
     +=3D (uint32_t)b->in[b->in_pos++] + 1;
   s->lzma2.sequence =3D s->lzma2.next_sequence;
   break;

  case SEQ_PROPERTIES:
   if (!lzma_props(s, b->in[b->in_pos++]))
    return XZ_DATA_ERROR;

   s->lzma2.sequence =3D SEQ_LZMA_PREPARE;

  case SEQ_LZMA_PREPARE:
   if (s->lzma2.compressed < 5)
    return XZ_DATA_ERROR;

   if (!rc_read_init(&s->rc, b))
    return XZ_OK;

   s->lzma2.compressed -=3D 5;
   s->lzma2.sequence =3D SEQ_LZMA_RUN;

  case SEQ_LZMA_RUN:
# 1066 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c"
   dict_limit(&s->dict, ({ size_t __min1 =3D (b->out_size - b->out_pos); si=
ze_t __min2 =3D (s->lzma2.uncompressed); __min1 < __min2 ? __min1: __min2; =
})

                           );
   if (!lzma2_lzma(s, b))
    return XZ_DATA_ERROR;

   s->lzma2.uncompressed -=3D dict_flush(&s->dict, b);

   if (s->lzma2.uncompressed =3D=3D 0) {
    if (s->lzma2.compressed > 0 || s->lzma.len > 0
      || !rc_is_finished(&s->rc))
     return XZ_DATA_ERROR;

    rc_reset(&s->rc);
    s->lzma2.sequence =3D SEQ_CONTROL;

   } else if (b->out_pos =3D=3D b->out_size
     || (b->in_pos =3D=3D b->in_size
      && s->temp.size
      < s->lzma2.compressed)) {
    return XZ_OK;
   }

   break;

  case SEQ_COPY:
   dict_uncompressed(&s->dict, b, &s->lzma2.compressed);
   if (s->lzma2.compressed > 0)
    return XZ_OK;

   s->lzma2.sequence =3D SEQ_CONTROL;
   break;
  }
 }

 return XZ_OK;
}

static struct xz_dec_lzma2 *xz_dec_lzma2_create(enum xz_mode mode,
         uint32_t dict_max)
{
 struct xz_dec_lzma2 *s =3D malloc(sizeof(*s));
 if (s =3D=3D ((void *)0))
  return ((void *)0);

 s->dict.mode =3D mode;
 s->dict.size_max =3D dict_max;

 if (((mode) =3D=3D XZ_PREALLOC)) {
  s->dict.buf =3D malloc(dict_max);
  if (s->dict.buf =3D=3D ((void *)0)) {
   free(s);
   return ((void *)0);
  }
 } else if (((mode) =3D=3D XZ_DYNALLOC)) {
  s->dict.buf =3D ((void *)0);
  s->dict.allocated =3D 0;
 }

 return s;
}

static enum xz_ret xz_dec_lzma2_reset(struct xz_dec_lzma2 *s, uint8_t props=
)
{

 if (props > 39)
  return XZ_OPTIONS_ERROR;

 s->dict.size =3D 2 + (props & 1);
 s->dict.size <<=3D (props >> 1) + 11;

 if (((s->dict.mode) !=3D XZ_SINGLE)) {
  if (s->dict.size > s->dict.size_max)
   return XZ_MEMLIMIT_ERROR;

  s->dict.end =3D s->dict.size;

  if (((s->dict.mode) =3D=3D XZ_DYNALLOC)) {
   if (s->dict.allocated < s->dict.size) {
    do { if (s->dict.buf !=3D ((void *)0)) free(s->dict.buf); } while (0);
    s->dict.buf =3D malloc(s->dict.size);
    if (s->dict.buf =3D=3D ((void *)0)) {
     s->dict.allocated =3D 0;
     return XZ_MEM_ERROR;
    }
   }
  }
 }

 s->lzma.len =3D 0;

 s->lzma2.sequence =3D SEQ_CONTROL;
 s->lzma2.need_dict_reset =3D true;

 s->temp.size =3D 0;

 return XZ_OK;
}

static void xz_dec_lzma2_end(struct xz_dec_lzma2 *s)
{
 if (((s->dict.mode) !=3D XZ_SINGLE))
  do { if (s->dict.buf !=3D ((void *)0)) free(s->dict.buf); } while (0);

 free(s);
}
# 236 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 2
# 1 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c" 1
# 19 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
struct xz_dec_bcj {

 enum {
  BCJ_X86 =3D 4,
  BCJ_POWERPC =3D 5,
  BCJ_IA64 =3D 6,
  BCJ_ARM =3D 7,
  BCJ_ARMTHUMB =3D 8,
  BCJ_SPARC =3D 9
 } type;






 enum xz_ret ret;


 bool single_call;






 uint32_t pos;


 uint32_t x86_prev_mask;


 uint8_t *out;
 size_t out_pos;
 size_t out_size;

 struct {

  size_t filtered;


  size_t size;
# 74 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
  uint8_t buf[16];
 } temp;
};
# 265 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
static size_t bcj_arm(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
{
 size_t i;
 uint32_t addr;

 for (i =3D 0; i + 4 <=3D size; i +=3D 4) {
  if (buf[i + 3] =3D=3D 0xEB) {
   addr =3D (uint32_t)buf[i] | ((uint32_t)buf[i + 1] << 8)
     | ((uint32_t)buf[i + 2] << 16);
   addr <<=3D 2;
   addr -=3D s->pos + (uint32_t)i + 8;
   addr >>=3D 2;
   buf[i] =3D (uint8_t)addr;
   buf[i + 1] =3D (uint8_t)(addr >> 8);
   buf[i + 2] =3D (uint8_t)(addr >> 16);
  }
 }

 return i;
}
# 345 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
static void bcj_apply(struct xz_dec_bcj *s,
        uint8_t *buf, size_t *pos, size_t size)
{
 size_t filtered;

 buf +=3D *pos;
 size -=3D *pos;

 switch (s->type) {
# 370 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
 case BCJ_ARM:
  filtered =3D bcj_arm(s, buf, size);
  break;
# 384 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
 default:

  filtered =3D 0;
  break;
 }

 *pos +=3D filtered;
 s->pos +=3D filtered;
}






static void bcj_flush(struct xz_dec_bcj *s, struct xz_buf *b)
{
 size_t copy_size;

 copy_size =3D ({ size_t __min1 =3D (s->temp.filtered); size_t __min2 =3D (=
b->out_size - b->out_pos); __min1 < __min2 ? __min1: __min2; });
 memcpy(b->out + b->out_pos, s->temp.buf, copy_size);
 b->out_pos +=3D copy_size;

 s->temp.filtered -=3D copy_size;
 s->temp.size -=3D copy_size;
 memmove(s->temp.buf, s->temp.buf + copy_size, s->temp.size);
}






static enum xz_ret xz_dec_bcj_run(struct xz_dec_bcj *s,
         struct xz_dec_lzma2 *lzma2,
         struct xz_buf *b)
{
 size_t out_start;






 if (s->temp.filtered > 0) {
  bcj_flush(s, b);
  if (s->temp.filtered > 0)
   return XZ_OK;

  if (s->ret =3D=3D XZ_STREAM_END)
   return XZ_STREAM_END;
 }
# 449 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
 if (s->temp.size < b->out_size - b->out_pos || s->temp.size =3D=3D 0) {
  out_start =3D b->out_pos;
  memcpy(b->out + b->out_pos, s->temp.buf, s->temp.size);
  b->out_pos +=3D s->temp.size;

  s->ret =3D xz_dec_lzma2_run(lzma2, b);
  if (s->ret !=3D XZ_STREAM_END
    && (s->ret !=3D XZ_OK || s->single_call))
   return s->ret;

  bcj_apply(s, b->out, &out_start, b->out_pos);






  if (s->ret =3D=3D XZ_STREAM_END)
   return XZ_STREAM_END;

  s->temp.size =3D b->out_pos - out_start;
  b->out_pos -=3D s->temp.size;
  memcpy(s->temp.buf, b->out + b->out_pos, s->temp.size);






  if (b->out_pos + s->temp.size < b->out_size)
   return XZ_OK;
 }
# 490 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
 if (b->out_pos < b->out_size) {

  s->out =3D b->out;
  s->out_pos =3D b->out_pos;
  s->out_size =3D b->out_size;
  b->out =3D s->temp.buf;
  b->out_pos =3D s->temp.size;
  b->out_size =3D sizeof(s->temp.buf);

  s->ret =3D xz_dec_lzma2_run(lzma2, b);

  s->temp.size =3D b->out_pos;
  b->out =3D s->out;
  b->out_pos =3D s->out_pos;
  b->out_size =3D s->out_size;

  if (s->ret !=3D XZ_OK && s->ret !=3D XZ_STREAM_END)
   return s->ret;

  bcj_apply(s, s->temp.buf, &s->temp.filtered, s->temp.size);






  if (s->ret =3D=3D XZ_STREAM_END)
   s->temp.filtered =3D s->temp.size;

  bcj_flush(s, b);
  if (s->temp.filtered > 0)
   return XZ_OK;
 }

 return s->ret;
}

static struct xz_dec_bcj *xz_dec_bcj_create(bool single_call)
{
 struct xz_dec_bcj *s =3D malloc(sizeof(*s));
 if (s !=3D ((void *)0))
  s->single_call =3D single_call;

 return s;
}

static enum xz_ret xz_dec_bcj_reset(struct xz_dec_bcj *s, uint8_t id)
{
 switch (id) {
# 549 "arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c"
 case BCJ_ARM:







  break;

 default:

  return XZ_OPTIONS_ERROR;
 }

 s->type =3D id;
 s->ret =3D XZ_OK;
 s->pos =3D 0;
 s->x86_prev_mask =3D 0;
 s->temp.filtered =3D 0;
 s->temp.size =3D 0;

 return XZ_OK;
}
# 237 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c" 2
# 251 "arch/arm/boot/compressed/../../../../lib/decompress_unxz.c"
static int unxz(unsigned char *in, int in_size,
       int (*fill)(void *dest, unsigned int size),
       int (*flush)(void *src, unsigned int size),
       unsigned char *out, int *in_used,
       void (*error)(char *x))
{
 struct xz_buf b;
 struct xz_dec *s;
 enum xz_ret ret;
 bool must_free_in =3D false;


 xz_crc32_init();


 if (in_used !=3D ((void *)0))
  *in_used =3D 0;

 if (fill =3D=3D ((void *)0) && flush =3D=3D ((void *)0))
  s =3D xz_dec_init(XZ_SINGLE, 0);
 else
  s =3D xz_dec_init(XZ_DYNALLOC, (uint32_t)-1);

 if (s =3D=3D ((void *)0))
  goto error_alloc_state;

 if (flush =3D=3D ((void *)0)) {
  b.out =3D out;
  b.out_size =3D (size_t)-1;
 } else {
  b.out_size =3D 4096;
  b.out =3D malloc(4096);
  if (b.out =3D=3D ((void *)0))
   goto error_alloc_out;
 }

 if (in =3D=3D ((void *)0)) {
  must_free_in =3D true;
  in =3D malloc(4096);
  if (in =3D=3D ((void *)0))
   goto error_alloc_in;
 }

 b.in =3D in;
 b.in_pos =3D 0;
 b.in_size =3D in_size;
 b.out_pos =3D 0;

 if (fill =3D=3D ((void *)0) && flush =3D=3D ((void *)0)) {
  ret =3D xz_dec_run(s, &b);
 } else {
  do {
   if (b.in_pos =3D=3D b.in_size && fill !=3D ((void *)0)) {
    if (in_used !=3D ((void *)0))
     *in_used +=3D b.in_pos;

    b.in_pos =3D 0;

    in_size =3D fill(in, 4096);
    if (in_size < 0) {





     ret =3D XZ_BUF_ERROR;
     break;
    }

    b.in_size =3D in_size;
   }

   ret =3D xz_dec_run(s, &b);

   if (flush !=3D ((void *)0) && (b.out_pos =3D=3D b.out_size
     || (ret !=3D XZ_OK && b.out_pos > 0))) {





    if (flush(b.out, b.out_pos) !=3D (int)b.out_pos)
     ret =3D XZ_BUF_ERROR;

    b.out_pos =3D 0;
   }
  } while (ret =3D=3D XZ_OK);

  if (must_free_in)
   free(in);

  if (flush !=3D ((void *)0))
   free(b.out);
 }

 if (in_used !=3D ((void *)0))
  *in_used +=3D b.in_pos;

 xz_dec_end(s);

 switch (ret) {
 case XZ_STREAM_END:
  return 0;

 case XZ_MEM_ERROR:

  error("XZ decompressor ran out of memory");
  break;

 case XZ_FORMAT_ERROR:
  error("Input is not in the XZ format (wrong magic bytes)");
  break;

 case XZ_OPTIONS_ERROR:
  error("Input was encoded with settings that are not "
    "supported by this XZ decoder");
  break;

 case XZ_DATA_ERROR:
 case XZ_BUF_ERROR:
  error("XZ-compressed data is corrupt");
  break;

 default:
  error("Bug in the XZ decompressor");
  break;
 }

 return -1;

error_alloc_in:
 if (flush !=3D ((void *)0))
  free(b.out);

error_alloc_out:
 xz_dec_end(s);

error_alloc_state:
 error("XZ decompressor ran out of memory");
 return -1;
}
# 51 "arch/arm/boot/compressed/decompress.c" 2


int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x))
{
 return unxz(input, len, ((void *)0), ((void *)0), output, ((void *)0), err=
or);
}

--=-H4eAEtgm1rSVBHZbd+VJ--

