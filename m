Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab0JaEEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 00:04:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63321 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0JaEEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 00:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TtIBcs0patu4H5IWT7mefVF/BLyQo9QIFrYyKhaae+pVTg6saN1nEnDxbpxvpmvnQb
         eiQ5BCKCUPMdEEL+OpuYuYA/v8nIf1DHnHHuKTeaP930qmwJcdGJDdIVsnz2qhna9egv
         LYEWbdvb5Zz459sIKNTbmIQWDgKkl9Gkw7p3k=
MIME-Version: 1.0
In-Reply-To: <c913cbdfddab78a4b7c840e0d8ff9754c306fc66.1288482645.git.joe@perches.com>
References: <cover.1288482645.git.joe@perches.com>
	<c913cbdfddab78a4b7c840e0d8ff9754c306fc66.1288482645.git.joe@perches.com>
Date: Sun, 31 Oct 2010 00:04:40 -0400
Message-ID: <AANLkTiniij6Xyq77mrm_FiuNfd4ggA+qHx6__6sfS_i_@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel/module.c: Use pr_<level> and pr_fmt
From: Arnaud Lacombe <lacombar@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[not that I'm fond of getting my mailbox full of whitespace patches, but...]

On Sat, Oct 30, 2010 at 7:58 PM, Joe Perches <joe@perches.com> wrote:
> Add missing KERN_CONT to printks
> Convert to pr_<level>
> Add "#define pr_fmt(fmt) fmt" so pr_<level> uses are not prefixed.
> Coalesce long formats for easier grep.
>
... until someone submit a new patch which would move back the the
line length to 80 char because check_<foo>.pl complained or because
they read  `Documentation/CodingStyle'. That's an interresting way to
endlessly submit patches without any functional improvement.

 - Arnaud

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  kernel/module.c |  108 +++++++++++++++++++++++-------------------------------
>  1 files changed, 46 insertions(+), 62 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 437a74a..9b6b0da 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -16,6 +16,9 @@
>     along with this program; if not, write to the Free Software
>     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>  */
> +
> +#define pr_fmt(fmt) fmt
> +
>  #include <linux/module.h>
>  #include <linux/moduleloader.h>
>  #include <linux/ftrace_event.h>
> @@ -315,26 +318,18 @@ static bool find_symbol_in_section(const struct symsearch *syms,
>                if (syms->licence == GPL_ONLY)
>                        return false;
>                if (syms->licence == WILL_BE_GPL_ONLY && fsa->warn) {
> -                       printk(KERN_WARNING "Symbol %s is being used "
> -                              "by a non-GPL module, which will not "
> -                              "be allowed in the future\n", fsa->name);
> -                       printk(KERN_WARNING "Please see the file "
> -                              "Documentation/feature-removal-schedule.txt "
> -                              "in the kernel source tree for more details.\n");
> +                       pr_warn("Symbol %s is being used by a non-GPL module, which will not be allowed in the future\n",
> +                               fsa->name);
> +                       pr_warn("Please see the file Documentation/feature-removal-schedule.txt in the kernel source tree for more details.\n");
>                }
>        }
>
>  #ifdef CONFIG_UNUSED_SYMBOLS
>        if (syms->unused && fsa->warn) {
> -               printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
> -                      "however this module is using it.\n", fsa->name);
> -               printk(KERN_WARNING
> -                      "This symbol will go away in the future.\n");
> -               printk(KERN_WARNING
> -                      "Please evalute if this is the right api to use and if "
> -                      "it really is, submit a report the linux kernel "
> -                      "mailinglist together with submitting your code for "
> -                      "inclusion.\n");
> +               pr_warn("Symbol %s is marked as UNUSED, however this module is using it.\n",
> +                       fsa->name);
> +               pr_warn("This symbol will go away in the future.\n");
> +               pr_warn("Please evalute if this is the right api to use and if it really is, submit a report to the linux kernel mailing list together with submitting your code for inclusion.\n");
>        }
>  #endif
>
> @@ -395,16 +390,15 @@ static int percpu_modalloc(struct module *mod,
>                           unsigned long size, unsigned long align)
>  {
>        if (align > PAGE_SIZE) {
> -               printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> -                      mod->name, align, PAGE_SIZE);
> +               pr_warn("%s: per-cpu alignment %li > %li\n",
> +                       mod->name, align, PAGE_SIZE);
>                align = PAGE_SIZE;
>        }
>
>        mod->percpu = __alloc_reserved_percpu(size, align);
>        if (!mod->percpu) {
> -               printk(KERN_WARNING
> -                      "%s: Could not allocate %lu bytes percpu data\n",
> -                      mod->name, size);
> +               pr_warn("%s: Could not allocate %lu bytes percpu data\n",
> +                       mod->name, size);
>                return -ENOMEM;
>        }
>        mod->percpu_size = size;
> @@ -578,7 +572,7 @@ static int add_module_usage(struct module *a, struct module *b)
>        DEBUGP("Allocating new usage for %s.\n", a->name);
>        use = kmalloc(sizeof(*use), GFP_ATOMIC);
>        if (!use) {
> -               printk(KERN_WARNING "%s: out of memory loading\n", a->name);
> +               pr_warn("%s: out of memory loading\n", a->name);
>                return -ENOMEM;
>        }
>
> @@ -947,8 +941,7 @@ static int try_to_force_load(struct module *mod, const char *reason)
>  {
>  #ifdef CONFIG_MODULE_FORCE_LOAD
>        if (!test_taint(TAINT_FORCED_MODULE))
> -               printk(KERN_WARNING "%s: %s: kernel tainted.\n",
> -                      mod->name, reason);
> +               pr_warn("%s: %s: kernel tainted\n", mod->name, reason);
>        add_taint_module(mod, TAINT_FORCED_MODULE);
>        return 0;
>  #else
> @@ -1001,13 +994,12 @@ static int check_version(Elf_Shdr *sechdrs,
>                goto bad_version;
>        }
>
> -       printk(KERN_WARNING "%s: no symbol version for %s\n",
> -              mod->name, symname);
> +       pr_warn("%s: no symbol version for %s\n", mod->name, symname);
>        return 0;
>
>  bad_version:
> -       printk("%s: disagrees about version of symbol %s\n",
> -              mod->name, symname);
> +       pr_warn("%s: disagrees about version of symbol %s\n",
> +               mod->name, symname);
>        return 0;
>  }
>
> @@ -1110,8 +1102,8 @@ resolve_symbol_wait(struct module *mod,
>                        !IS_ERR(ksym = resolve_symbol(mod, info, name, owner))
>                        || PTR_ERR(ksym) != -EBUSY,
>                                             30 * HZ) <= 0) {
> -               printk(KERN_WARNING "%s: gave up waiting for init of module %s.\n",
> -                      mod->name, owner);
> +               pr_warn("%s: gave up waiting for init of module %s\n",
> +                       mod->name, owner);
>        }
>        return ksym;
>  }
> @@ -1419,15 +1411,14 @@ static int mod_sysfs_init(struct module *mod)
>        struct kobject *kobj;
>
>        if (!module_sysfs_initialized) {
> -               printk(KERN_ERR "%s: module sysfs not initialized\n",
> -                      mod->name);
> +               pr_err("%s: module sysfs not initialized\n", mod->name);
>                err = -EINVAL;
>                goto out;
>        }
>
>        kobj = kset_find_obj(module_kset, mod->name);
>        if (kobj) {
> -               printk(KERN_ERR "%s: module is already loaded\n", mod->name);
> +               pr_err("%s: module is already loaded\n", mod->name);
>                kobject_put(kobj);
>                err = -EINVAL;
>                goto out;
> @@ -1623,9 +1614,7 @@ static int verify_export_symbols(struct module *mod)
>        for (i = 0; i < ARRAY_SIZE(arr); i++) {
>                for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
>                        if (find_symbol(s->name, &owner, NULL, true, false)) {
> -                               printk(KERN_ERR
> -                                      "%s: exports duplicate symbol %s"
> -                                      " (owned by %s)\n",
> +                               pr_err("%s: exports duplicate symbol %s (owned by %s)\n",
>                                       mod->name, s->name, module_name(owner));
>                                return -ENOEXEC;
>                        }
> @@ -1652,8 +1641,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>                        /* We compiled with -fno-common.  These are not
>                           supposed to happen.  */
>                        DEBUGP("Common symbol: %s\n", name);
> -                       printk("%s: please compile with -fno-common\n",
> -                              mod->name);
> +                       pr_info("%s: please compile with -fno-common\n",
> +                               mod->name);
>                        ret = -ENOEXEC;
>                        break;
>
> @@ -1675,8 +1664,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>                        if (!ksym && ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
>                                break;
>
> -                       printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
> -                              mod->name, name, PTR_ERR(ksym));
> +                       pr_warn("%s: Unknown symbol %s (err %li)\n",
> +                               mod->name, name, PTR_ERR(ksym));
>                        ret = PTR_ERR(ksym) ?: -ENOENT;
>                        break;
>
> @@ -1808,8 +1797,8 @@ static void set_license(struct module *mod, const char *license)
>
>        if (!license_is_gpl_compatible(license)) {
>                if (!test_taint(TAINT_PROPRIETARY_MODULE))
> -                       printk(KERN_WARNING "%s: module license '%s' taints "
> -                               "kernel.\n", mod->name, license);
> +                       pr_warn("%s: module license '%s' taints kernel\n",
> +                               mod->name, license);
>                add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
>        }
>  }
> @@ -2048,8 +2037,8 @@ static void dynamic_debug_setup(struct _ddebug *debug, unsigned int num)
>                return;
>  #ifdef CONFIG_DYNAMIC_DEBUG
>        if (ddebug_add_module(debug, num, debug->modname))
> -               printk(KERN_ERR "dynamic debug error adding module: %s\n",
> -                                       debug->modname);
> +               pr_err("dynamic debug error adding module: %s\n",
> +                      debug->modname);
>  #endif
>  }
>
> @@ -2163,8 +2152,7 @@ static int rewrite_section_headers(struct load_info *info)
>                Elf_Shdr *shdr = &info->sechdrs[i];
>                if (shdr->sh_type != SHT_NOBITS
>                    && info->len < shdr->sh_offset + shdr->sh_size) {
> -                       printk(KERN_ERR "Module len %lu truncated\n",
> -                              info->len);
> +                       pr_err("Module len %lu truncated\n", info->len);
>                        return -ENOEXEC;
>                }
>
> @@ -2223,15 +2211,14 @@ static struct module *setup_load_info(struct load_info *info)
>
>        info->index.mod = find_sec(info, ".gnu.linkonce.this_module");
>        if (!info->index.mod) {
> -               printk(KERN_WARNING "No module found in object\n");
> +               pr_warn("No module found in object\n");
>                return ERR_PTR(-ENOEXEC);
>        }
>        /* This is temporary: point mod into copy of data. */
>        mod = (void *)info->sechdrs[info->index.mod].sh_addr;
>
>        if (info->index.sym == 0) {
> -               printk(KERN_WARNING "%s: module has no symbols (stripped?)\n",
> -                      mod->name);
> +               pr_warn("%s: module has no symbols (stripped?)\n", mod->name);
>                return ERR_PTR(-ENOEXEC);
>        }
>
> @@ -2255,16 +2242,15 @@ static int check_modinfo(struct module *mod, struct load_info *info)
>                if (err)
>                        return err;
>        } else if (!same_magic(modmagic, vermagic, info->index.vers)) {
> -               printk(KERN_ERR "%s: version magic '%s' should be '%s'\n",
> +               pr_err("%s: version magic '%s' should be '%s'\n",
>                       mod->name, modmagic, vermagic);
>                return -ENOEXEC;
>        }
>
>        if (get_modinfo(info, "staging")) {
>                add_taint_module(mod, TAINT_CRAP);
> -               printk(KERN_WARNING "%s: module is from the staging directory,"
> -                      " the quality is unknown, you have been warned.\n",
> -                      mod->name);
> +               pr_warn("%s: module is from the staging directory, the quality is unknown, you have been warned.\n",
> +                       mod->name);
>        }
>
>        /* Set up license info based on the info section */
> @@ -2337,8 +2323,7 @@ static void find_module_sections(struct module *mod, struct load_info *info)
>                                    sizeof(*mod->extable), &mod->num_exentries);
>
>        if (section_addr(info, "__obsparm"))
> -               printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
> -                      mod->name);
> +               pr_warn("%s: Ignoring obsolete parameters\n", mod->name);
>
>        info->debug = section_objs(info, "__verbose",
>                                   sizeof(*info->debug), &info->num_debug);
> @@ -2727,11 +2712,10 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>                return ret;
>        }
>        if (ret > 0) {
> -               printk(KERN_WARNING
> -"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
> -"%s: loading module anyway...\n",
> -                      __func__, mod->name, ret,
> -                      __func__);
> +               pr_warn(
> +"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n%s: loading module anyway...\n",
> +                       __func__, mod->name, ret,
> +                       __func__);
>                dump_stack();
>        }
>
> @@ -3200,11 +3184,11 @@ void print_modules(void)
>        /* Most callers should already have preempt disabled, but make sure */
>        preempt_disable();
>        list_for_each_entry_rcu(mod, &modules, list)
> -               printk(" %s%s", mod->name, module_flags(mod, buf));
> +               pr_cont(" %s%s", mod->name, module_flags(mod, buf));
>        preempt_enable();
>        if (last_unloaded_module[0])
> -               printk(" [last unloaded: %s]", last_unloaded_module);
> -       printk("\n");
> +               pr_cont(" [last unloaded: %s]", last_unloaded_module);
> +       pr_cont("\n");
>  }
>
>  #ifdef CONFIG_MODVERSIONS
> --
> 1.7.3.1.g432b3.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
